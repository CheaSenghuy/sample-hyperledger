rm -rf channel-artifacts
rm -rf crypto-config    
rm -rf ledger 
rm -rf ledger2

docker rm -r $(docker ps -aq)
docker volume prune