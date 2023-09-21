#!/bin/zsh
# export FABRIC_CFG_PATH=${PWD}/config
configtxgen -outputBlock ./channel-artifacts/genesis.block -profile TwoOrgsApplicationGenesis -channelID genesis-channel  -configPath ${PWD}/config