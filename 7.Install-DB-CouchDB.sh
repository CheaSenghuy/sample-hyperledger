docker container stop couchdb
docker container rm -f couchdb


docker container stop couchdb2
docker container rm -f couchdb2


docker run -e COUCHDB_USER=admin -e COUCHDB_PASSWORD=123 --name couchdb -p 5984:5984 -d couchdb --restart unless-stopped
docker run -e COUCHDB_USER=admin -e COUCHDB_PASSWORD=123  --name couchdb2 -p 5985:5984 -d couchdb --restart unless-stopped

sleep 3

curl localhost:5984
curl localhost:5985
