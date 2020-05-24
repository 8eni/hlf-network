#!/bin/bash

export PATH=${PWD}/../bin:${PWD}:$PATH

which cryptogen
echo "##########################################################"
echo "##### Generate certificates using cryptogen tool #########"
echo "##########################################################"

if [ -d "crypto-config" ]; then
    rm -Rf crypto-config
fi
set -x
cryptogen generate --config=./crypto-config.yaml