export FABRIC_CFG_PATH=$PWD/config
cp -R ./ledger ./ledger2


# Variable for setting peer address
export CORE_PEER_ID="Org1MSP"
export CORE_PEER_LOCALMSPID="Org1MSP"
export CORE_PEER_LISTENADDRESS=0.0.0.0:7051
export CORE_PEER_ADDRESS=localhost:7051
export CORE_PEER_GOSSIP_BOOTSTRAP=localhost:7051
export CORE_PEER_GOSSIP_EXTERNALENDPOINT=localhost:7051
export CORE_OPERATIONS_LISTENADDRESS=localhost:9445
# export CORE_PEER_CHAINCODEADDRESS=localhost:7052
# export CORE_PEER_CHAINCODELISTENADDRESS=localhost:7052
export CORE_PEER_CHAINCODELISTENADDRESS=0.0.0.0:7052
export CORE_PEER_FILESYSTEMPATH=${PWD}/ledger
export CORE_LEDGER_SNAPSHOTS_ROOTDIR=${PWD}/ledger
export CORE_PEER_TLS_ENABLED=true

# Identity set to ADMIN
export CORE_PEER_MSPCONFIGPATH=${PWD}/crypto-config/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
export CORE_PEER_TLS_KEY_FILE=${PWD}/crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/server.key
export CORE_PEER_TLS_CERT_FILE=${PWD}/crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/server.crt


# State Data persistence in CouchDB
export CORE_LEDGER_STATE_STATEDATABASE=CouchDB
export CORE_LEDGER_STATE_COUCHDBCONFIG_COUCHDBADDRESS=localhost:5984
export CORE_LEDGER_STATE_COUCHDBCONFIG_USERNAME=admin
export CORE_LEDGER_STATE_COUCHDBCONFIG_PASSWORD=123



# Launch peer 
peer node start