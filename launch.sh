#!/bin/bash
#
# Copyright IBM Corp All Rights Reserved
#
# SPDX-License-Identifier: Apache-2.0
#
# Exit on first error, print all commands.
set -ev

docker-compose -f docker-compose.yml down

docker-compose -f docker-compose.yml up -d orderer.example.com peer0.manufacturer.example.com peer1.manufacturer.example.com cli

# wait for Hyperledger Fabric to start
# incase of errors when running later commands, issue export FABRIC_START_TIMEOUT=<larger number>
export FABRIC_START_TIMEOUT=10
#echo ${FABRIC_START_TIMEOUT}
sleep ${FABRIC_START_TIMEOUT}

# Create the channel
docker exec -e "CORE_PEER_LOCALMSPID=ManufacturerMSP" -e "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/msp/users/Admin@manufacturer.example.com/msp" \
peer0.manufacturer.example.com peer channel create -o orderer.example.com:7050 -c supplychannel -f /etc/hyperledger/configtx/channel.tx
# Join peer0.manufacturer.example.com to the channel.
docker exec -e "CORE_PEER_LOCALMSPID=ManufacturerMSP" -e "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/msp/users/Admin@manufacturer.example.com/msp" \
peer0.manufacturer.example.com peer channel join -b supplychannel.block
