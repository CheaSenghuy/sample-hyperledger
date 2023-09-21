
export FABRIC_CFG_PATH=${PWD}/config
configtxgen -profile TwoOrgsApplicationGenesis -outputCreateChannelTx ./channel-artifacts/mychannel.tx -channelID mychannel