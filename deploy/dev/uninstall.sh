docker-compose -f docker-compose-api.yaml down -v --remove-orphans
docker-compose -f docker-compose-test-net.yaml down -v
docker-compose -f docker-compose-ca.yaml down -v
rm -rf wallet
rm -rf channel-artifacts
rm -rf system-genesis-block
find organizations \! -name 'fabric-ca-server-config.yaml' -delete
find connection-profile \! -name 'ccp-template*' -delete