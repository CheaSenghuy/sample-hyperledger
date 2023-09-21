 export FABRIC_CFG_PATH=${PWD}/config
 export CORE_PEER_TLS_ENABLED=true
 export PEER0_ORG1_CA=${PWD}/crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
 export PEER0_ORG2_CA=${PWD}/crypto-config/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt


 #Setup Environment For ORG1
 setGobalForPeer0Org1(){
    export CORE_PEER_LOCALMSPID="Org1MSP"
    export CORE_PEER_ID="Org1MSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG1_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/crypto-config/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
    export CORE_PEER_ADDRESS=localhost:7051
 }

 #SetUp Enviroment For Org2
 setGobaleForPeer0Org2(){
    export CORE_PEER_LOCALMSPID="Org2MSP"
    export CORE_PEER_ID="Org2MSP"
    export CORE_PEER_MSPCONFIGPATH=${PWD}/crypto-config/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG2_CA
   export CORE_PEER_ADDRESS=localhost:7053
 }
 
 joinChannel1(){
    setGobalForPeer0Org1
    peer channel join -b ./channel-artifacts/mychannel.block
    peer channel list
 }

 joinChannel2(){
    setGobaleForPeer0Org2
    peer channel join -b ./channel-artifacts/mychannel.block
    peer channel list 
 }
 
 joinChannel1
 joinChannel2
