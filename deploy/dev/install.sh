docker-compose -f docker-compose-ca.yaml up -d
sleep 10
./create-certs.sh
./create-artifact.sh
docker-compose -f docker-compose-test-net.yaml up -d
sleep 10
./init-channel.sh
./init-cc.sh
./init-ccp.sh
sleep 10
docker-compose -f docker-compose-api.yaml up -d