!/bin/zsh
export FABRIC_CFG_PATH=${PWD}/config
export FABRIC_LOGGING_SPEC=INFO
export ORDERER_FILELEDGER_LOCATION=../ledger/
export ORDERER_GENERAL_LOCALMSPID="OrdererMSP"
export ORDERER_GENERAL_LOCALMSPDIR=${PWD}/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp

# Finding File Config
export ORDERER_GENERAL_BOOTSTRAPMETHOD=file
export ORDERER_GENERAL_BOOTSTRAPFILE=${PWD}/channel-artifacts/genesis.block
export CORE_PEER_MSPCONFIGPATH=${PWD}/crypto-config/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp

# Enable TLS
export ORDERER_GENERAL_TLS_ENABLED=true
export ORDERER_GENERAL_TLS_PRIVATEKEY=${PWD}/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/tls/server.key
export ORDERER_GENERAL_TLS_CERTIFICATE=${PWD}/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/tls/server.crt
export ORDERER_GENERAL_TLS_ROOTCAS=${PWD}/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/tls/ca.crt

orderer
