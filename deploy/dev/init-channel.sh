docker exec -it cli-peer0-org1 /bin/bash -c "./scripts/createAppChannel.sh"
docker exec -it cli-peer0-org1 /bin/bash -c "peer channel join -b ./channel-artifacts/mychannel.block"
docker exec -it cli-peer0-org1 /bin/bash -c "peer channel list"
docker exec -it cli-peer0-org1 /bin/bash -c "./scripts/updateAnchorPeer.sh Org1MSP"