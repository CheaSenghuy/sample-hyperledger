 export FABRIC_CFG_PATH=./config
 CC_SRC_PATH="./chaincode"
 CC_NAME="mycc"
 CC_RUNTIME_LANGUAGE="golang"
 CC_VERSION="1.0"1
 CC_SEQUENCE="1"
 CHANNEL_NAME="mychannel"
 export PRIVATE_DATA_CONFIG=${PWD}/config/collections_config.json
 

 export CORE_PEER_TLS_ROOTCERT_FILE1=${PWD}/crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
 export CORE_PEER_TLS_ROOTCERT_FILE2=${PWD}/crypto-config/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt
 export ORDERER_CA=${PWD}/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem


 CA1=${PWD}/crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
 export PEER0_ORG1_CA=${PWD}/crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
 export FABRIC_LOGGING_SPEC=debug

 export ORDERER_GENERAL_TLS_ENABLED=true
 export ORDERER_GENERAL_LOCALMSPDIR=${PWD}/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp
 export ORDERER_GENERAL_TLS_PRIVATEKEY=${PWD}/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/tls/server.key
 export ORDERER_GTENERAL_TLS_CERTIFICATE=${PWD}/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/tls/server.crt
 export ORDERER_GENERAL_TLS_ROOTCAS=${PWD}/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/tls/ca.crt

 setGobalsForPeerOrg1() {
    export CORE_PEER_LOCALMSPID="Org1MSP"
    export CORE_PEER_ID="Org1MSP"
    # export CORE_PEER_MSPCONFIGPATH=${PWD}/crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/msp
    export CORE_PEER_MSPCONFIGPATH=${PWD}/crypto-config/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
    export CORE_PEER_ADDRESS=localhost:7051

    export CORE_PEER_TLS_ENABLED=true
    export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
    export CORE_PEER_TLS_KEY_FILE=${PWD}/crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/server.key
    export CORE_PEER_TLS_KEY_CERT_FILE=${PWD}/crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/server.crt
    export CORE_PEER_TLS_CLIENTROOTCAS_FILE=${PWD}/crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
 }


 setGobalsForPeerOrg2() {
    export CORE_PEER_LOCALMSPID="Org2MSP"
    export CORE_PEER_ID="Org2MSP"
    # export CORE_PEER_MSPCONFIGPATH=${PWD}/crypto-config/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/msp
    export CORE_PEER_MSPCONFIGPATH=export CORE_PEER_MSPCONFIGPATH=${PWD}/crypto-config/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp
    
    export CORE_PEER_ADDRESS=localhost:7053

    export CORE_PEER_TLS_ENABLED=true
    export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/crypto-config/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt
    export CORE_PEER_TLS_KEY_FILE=${PWD}/crypto-config/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/server.key
    export CORE_PEER_TLS_KEY_CERT_FILE=${PWD}/crypto-config/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/server.crt
    export CORE_PEER_TLS_CLIENTROOTCAS_FILE=${PWD}/crypto-config/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt
 }



perSetup(){
   echo GO dependencies ...
   pushd ./chaincode
   GO111MODULE=on go mod vendor
   popd
   echo Finish
}

#Package ChainCode
packageChainCode(){
    setGobalsForPeerOrg1
    rm -rf $(CC_NAME).tar.gz
    # peer lifecycle chaincode package $CC_NAME --path $CC_SRC_PATH --lang $CC_RUNTIME_LANGUAGE --label $CC_NAME --tls --cafile $ORDERER_CA
    peer lifecycle chaincode package $CC_NAME.tar.gz --path $CC_SRC_PATH --lang $CC_RUNTIME_LANGUAGE --label $CC_NAME
    echo "================== ChainCode is packaged on Peer0.Org1 ========================"
}

installChaincode(){
    setGobalsForPeerOrg1
    peer lifecycle chaincode install ${CC_NAME}.tar.gz 
    echo =============== ChainCode is installed on Peer0.Org1 ===================

    setGobalsForPeerOrg2
    peer lifecycle chaincode install ${CC_NAME}.tar.gz
    echo "============= ChainCode is installed on Peer0.Org2 ==================="

}


queryInstalled(){
    setGobalsForPeerOrg1
    peer lifecycle chaincode queryinstalled \ >&log.txt

    # PACKAGE_ID=$(awk '/Package ID:/{sub("Package ID: ", ""); print}' log.txt | sed 's/, Label: mycc//')
    PACKAGE_ID=$(awk '/Package ID:/{sub("Package ID: ", ""); print}' log.txt | sed 's/, Label: mycc//')
    echo PackageID is ${PACKAGE_ID}
    echo "==================================== Query installed successful on peer0.org1 on channel ===================================="
}

approveForMyOrg1() {
    setGobalsForPeerOrg1
    set -x
    peer lifecycle chaincode approveformyorg -o localhost:7050 \
    --ordererTLSHostnameOverride orderer.example.com --tls \
    --cafile $ORDERER_CA \
    --collections-config ${PRIVATE_DATA_CONFIG} \
    --channelID $CHANNEL_NAME --name ${CC_NAME} --version ${CC_VERSION} \
    --sequence ${CC_SEQUENCE} --init-required --package-id ${PACKAGE_ID}
    echo "=========== Chaincode approved from org 1 ============="
}

approveForMyOrg2() {
    setGobalsForPeerOrg2
    set -x
     peer lifecycle chaincode approveformyorg -o localhost:7050 \
    --ordererTLSHostnameOverride orderer.example.com --tls \
    --cafile $ORDERER_CA \
    --collections-config ${PRIVATE_DATA_CONFIG} \
    --channelID $CHANNEL_NAME --name ${CC_NAME} --version ${CC_VERSION} \
    --sequence ${CC_SEQUENCE} --init-required --package-id ${PACKAGE_ID}
    echo "====chaincode approved from org 2 ========="
}


checkCommitReadyness(){
    setGlobalsForPeerOrg1

    peer lifecycle chaincode checkcommitreadiness \
    --ordererTLSHostnameOverride orderer.example.com --tls \
    --cafile $ORDERER_CA \
    --collections-config ${PRIVATE_DATA_CONFIG} \
    --channelID ${CHANNEL_NAME} --name ${CC_NAME} --version ${CC_VERSION} \
    --sequence ${CC_SEQUENCE} --output json --init-required
    echo "==================================== checking commit readiness from org 1 ===================================="
}

commitChaincodeDefination(){
    setGlobalsForPeerOrg1
    
    peer lifecycle chaincode commit -o localhost:7050 \
    --ordererTLSHostnameOverride orderer.example.com \
    --tls --cafile $ORDERER_CA \
    --channelID $CHANNEL_NAME --name ${CC_NAME} \
    --collections-config $PRIVATE_DATA_CONFIG \
    --peerAddresses localhost:7051 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE1 \
    --peerAddresses localhost:7053 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE2 \
    --version ${CC_VERSION} --sequence ${CC_SEQUENCE} --init-required
}


queryCommitted() {
    setGobalsForPeerOrg1
    peer lifecycle chaincode querycommitted --channelID $CHANNEL_NAME --name ${CC_NAME}
}


chaincodeInvokeInit(){
    setGobalsForPeerOrg1

    peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile ${ORDERER_CA} \
    -C $CHANNEL_NAME --name ${CC_NAME} \
    --peerAddresses localhost:7051 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE1 \
    --peerAddresses localhost:7053 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE2 \
    --isInit -c '{"Args":["InitLedger"]}'
}

chaincodeInvokeAdd(){
    setGobalsForPeerOrg2

    peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile ${ORDERER_CA} \
    -C $CHANNEL_NAME --name ${CC_NAME} \
    --peerAddresses localhost:7051 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE1 \
    --peerAddresses localhost:7053 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE2 \
    -c '{"function":"CreateAsset","Args":["asset20","black","16","12","750"]}'
}

chaincodeInvokeGet(){
    setGobalsForPeerOrg1

    peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile ${ORDERER_CA} \
    -C $CHANNEL_NAME --name ${CC_NAME} \
    --peerAddresses localhost:7051 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE1 \
    --peerAddresses localhost:7053 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE2 \
    -c '{"Args":["GetAllAssets"]}'
}

chaincodeInvokeUpdate(){
    setGobalsForPeerOrg2

    peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile ${ORDERER_CA} \
    -C $CHANNEL_NAME --name ${CC_NAME} \
    --peerAddresses localhost:7051 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE1 \
    --peerAddresses localhost:7053 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE2 \
    -c '{"function":"TransferAsset","Args":["asset20","Yuji"]}'
}


queryData(){
    setGobalsForPeerOrg1
    peer chaincode query -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile ${ORDERER_CA} \
    -C $CHANNEL_NAME --name ${CC_NAME} \
    -c  '{"Args":["GetAllAssets"]}'
    # -c  '{"Args":["ReadAsset","asset1"]}'
}

chaincodeDelete(){
    setGobalsForPeerOrg1
    peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile ${ORDERER_CA} \
    -C $CHANNEL_NAME --name ${CC_NAME} \
    --peerAddresses localhost:7051 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE1 \
    --peerAddresses localhost:7053 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE2 \
    -c '{"function":"DeleteAsset","Args":["asset8"]}'
}

chaincodeUpdateAsset(){
    setGobalsForPeerOrg1
    peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile ${ORDERER_CA} \
    -C $CHANNEL_NAME --name ${CC_NAME} \
    --peerAddresses localhost:7051 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE1 \
    --peerAddresses localhost:7053 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE2 \
    -c '{"function":"UpdateAsset","Args":["asset8","red","20","900"]}'
}



#! Step0
# perSetup
# ! Step1
# packageChainCode
# # #! Step2
# installChaincode
# #! Step3 Query to store Package ID 
# queryInstalled

# # * Need to Approve one by one 
# approveForMyOrg1
# # * Need to Approve Org2 after Org1
# approveForMyOrg2

# # # # ! Step4  Checking Commited 

# checkCommitReadyness
# commitChaincodeDefination
# queryCommitted

# ! Step5 InvokeInit
queryInstalled
# chaincodeInvokeInit
# chaincodeInvokeAdd
# chaincodeInvokeGet
# chaincodeInvokeUpdate
# chaincodeDelete
queryData

