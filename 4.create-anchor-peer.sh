!/bin/zsh
# export FABRIC_CFG_PATH=./config
configtxgen -outputAnchorPeersUpdate ./channel-artifacts/anchor_peer_tx1.pb -profile TwoOrgsApplicationGenesis -asOrg Org1MSP -channelID mychannel -configPath ${PWD}/config
configtxgen -outputAnchorPeersUpdate ./channel-artifacts/anchor_peer_tx2.pb -profile TwoOrgsApplicationGenesis -asOrg Org2MSP -channelID mychannel -configPath ${PWD}/config