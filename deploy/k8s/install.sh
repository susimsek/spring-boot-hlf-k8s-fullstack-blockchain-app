#!/bin/bash


# Functions #########################################################################

function create_pv(){
echo "## Fabric files pv deployed"
echo
kubectl apply -f pv/
}

function create_pvc(){
echo "## Fabric files pvc deployed"
echo
kubectl apply -f pvc/
}

function create_fabric_ca_server(){
echo "## Fabric ca server deployed"
echo
kubectl apply -f ca/

echo "## Fabric ca server creation pending completion"
kubectl wait --for condition=available --timeout=300s deployment -l "app in (ca-orderer,ca-org1,ca-org2,ca-org3)"
}

function create_certificates(){
echo "## Certificates for peers and orderers created"
echo
kubectl apply -f job/create-certs.yaml

echo "## Certificate creation job pending completion"
kubectl wait --for=condition=complete --timeout=300s job create-certs
}

function create_artifacts(){
echo "## Genesis block and channel transaction created"
echo
kubectl apply -f job/create-artifacts.yaml

echo "## Artifact creation job pending completion"
kubectl wait --for=condition=complete --timeout=300s job create-artifacts
}

function create_kafka(){
echo "## Kafka deployed"
echo
kubectl apply -f kafka/

echo "## Kafka creation pending completion"
kubectl wait --for condition=ready --timeout=300s pod -l "app in (zookeeper,kafka)"
}

function create_orderer(){
echo "## Orderer deployed"
echo
kubectl apply -f orderer/

echo "## Orderer pending completion"
kubectl wait --for condition=available --timeout=300s deployment -l "app in (orderer,orderer2,orderer3,orderer4,orderer5)"
}

function create_peer(){
echo "## Peer deployed"
echo
kubectl apply -f peer/builder-config.yaml
echo "## Org1 Peer deployed"
echo
kubectl apply -f peer/org1/
echo "## Org2 Peer deployed"
echo
kubectl apply -f peer/org2/
echo "## Org3 Peer deployed"
echo
kubectl apply -f peer/org3/

echo "## Peer pending completion"
echo "## Org1 Peer pending completion"
echo
kubectl wait --for condition=available --timeout=300s deployment -l "app in (peer0-org1-couchdb,peer0-org1,cli-peer0-org1)"
echo "## Org2 Peer pending completion"
echo
kubectl wait --for condition=available --timeout=300s deployment -l "app in (peer0-org2-couchdb,peer0-org2,cli-peer0-org2)"
echo "## Org3 Peer pending completion"
echo
kubectl wait --for condition=available --timeout=300s deployment -l "app in (peer0-org3-couchdb,peer0-org3,cli-peer0-org3)"
}

function create_app_channel(){
echo "## Application channel created"
sleep 25
echo
kubectl apply -f job/create-app-channel.yaml

echo "## Application channel creation job pending completion"
kubectl wait --for=condition=complete --timeout=300s job create-app-channel
}

function join_app_channel(){
echo "## Application channel joined"
echo
kubectl apply -f job/join-app-channel.yaml

echo "## Application channel joining job pending completion"
kubectl wait --for=condition=complete --timeout=300s job join-app-channel
}

function update_anchor_peer(){
echo "## Anchor Peer Updated"
echo
kubectl apply -f job/update-anchor-peer.yaml

echo "## Anchor peer updating job pending completion"
kubectl wait --for=condition=complete --timeout=300s job update-anchor-peer
}

function package_chaincode(){
echo "## Chaincode packaging"
echo
kubectl apply -f job/package-chaincode.yaml

echo "## Chaincode packaging job pending completion"
kubectl wait --for=condition=complete --timeout=300s job package-chaincode
}


function install_chaincode(){
echo "## Chaincode installed"
echo
kubectl apply -f job/install-chaincode.yaml

echo "## Chaincode installing job pending completion"
kubectl wait --for=condition=complete --timeout=300s job install-chaincode
}

function deploy_chaincode(){
echo "## Chaincode deployed"
echo
kubectl apply -f cc/

echo "## Chanicode creation pending completion"
kubectl wait --for condition=available --timeout=300s deployment -l "app in (chaincode-basic-org1,chaincode-basic-org2,chaincode-basic-org3)"
}

function approve_chaincode(){
echo "## Chaincode approved"
echo
kubectl apply -f job/approve-chaincode.yaml

echo "## Chaincode approving job pending completion"
kubectl wait --for=condition=complete --timeout=300s job approve-chaincode
}

function check_commit_readness(){
echo "## Check commit readness"
echo
kubectl apply -f job/check-commit-readiness.yaml

echo "## Commit readness job pending completion"
kubectl wait --for=condition=complete --timeout=300s job check-commit-readiness
}

function commit_chaincode(){
echo "## Chaincode commited"
echo
kubectl apply -f job/commit-chaincode.yaml

echo "## Chanicode commiting job pending completion"
kubectl wait --for=condition=complete --timeout=300s job commit-chaincode
}

function create_connection_json(){
echo "## connection.json file created"
echo
CHAINCODE_ORG1_ADDRESS=basic-org1:7052
CHAINCODE_ORG2_ADDRESS=basic-org2:7052
CHAINCODE_ORG3_ADDRESS=basic-org3:7052

kubectl exec -it $(kubectl get pod -l "app=peer0-org1" -o jsonpath='{.items[0].metadata.name}') -- /bin/sh -c "cd /var/hyperledger/production/externalbuilder/builds/*/release/chaincode/server && echo '{\"address\":\"${CHAINCODE_ORG1_ADDRESS}\",\"dial_timeout\":\"10s\",\"tls_required\":false,\"client_auth_required\":false,\"client_key\":\"-----BEGIN EC PRIVATE KEY----- ... -----END EC PRIVATE KEY-----\",\"client_cert\":\"-----BEGIN CERTIFICATE----- ... -----END CERTIFICATE-----\",\"root_cert\":\"-----BEGIN CERTIFICATE---- ... -----END CERTIFICATE-----\"}' >> connection.json"
kubectl exec -it $(kubectl get pod -l "app=peer0-org2" -o jsonpath='{.items[0].metadata.name}') -- /bin/sh -c "cd /var/hyperledger/production/externalbuilder/builds/*/release/chaincode/server && echo '{\"address\":\"${CHAINCODE_ORG2_ADDRESS}\",\"dial_timeout\":\"10s\",\"tls_required\":false,\"client_auth_required\":false,\"client_key\":\"-----BEGIN EC PRIVATE KEY----- ... -----END EC PRIVATE KEY-----\",\"client_cert\":\"-----BEGIN CERTIFICATE----- ... -----END CERTIFICATE-----\",\"root_cert\":\"-----BEGIN CERTIFICATE---- ... -----END CERTIFICATE-----\"}' >> connection.json"
kubectl exec -it $(kubectl get pod -l "app=peer0-org3" -o jsonpath='{.items[0].metadata.name}') -- /bin/sh -c "cd /var/hyperledger/production/externalbuilder/builds/*/release/chaincode/server && echo '{\"address\":\"${CHAINCODE_ORG3_ADDRESS}\",\"dial_timeout\":\"10s\",\"tls_required\":false,\"client_auth_required\":false,\"client_key\":\"-----BEGIN EC PRIVATE KEY----- ... -----END EC PRIVATE KEY-----\",\"client_cert\":\"-----BEGIN CERTIFICATE----- ... -----END CERTIFICATE-----\",\"root_cert\":\"-----BEGIN CERTIFICATE---- ... -----END CERTIFICATE-----\"}' >> connection.json"
}

function init_ledger_data(){
echo "## Ledger data created"
echo
kubectl apply -f job/init-ledger-data.yaml

echo "## Ledger data creating job pending completion"
kubectl wait --for=condition=complete --timeout=300s job init-ledger-data
}

function create_connection_profile(){
echo "## Connection profile created"
echo
kubectl apply -f job/create-connection-profile.yaml

echo "## Connection profile creating job pending completion"
kubectl wait --for=condition=complete --timeout=300s job create-connection-profile
}

function create_api(){
echo "## Backend deployed"
echo
kubectl apply -f api/

echo "## Backend creation pending completion"
kubectl wait --for condition=available --timeout=300s deployment -l "app in (api)"
}

function create_ui(){
echo "## Frontend deployed"
echo
kubectl apply -f ui/

echo "## Frontend creation pending completion"
kubectl wait --for condition=available --timeout=300s deployment -l "app in (frontend)"
}

function create_explorer(){
echo "## Hyperledger explorer deployed"
echo
kubectl apply -f explorer/

echo "## Hyperledger explorer creation pending completion"
kubectl wait --for condition=available --timeout=300s deployment -l "app in (explorer,explorer-db)"
}

function create_monitoring_tool(){
echo "## Grafana,Prometheus deployed"
echo
kubectl apply -f monitoring/

echo "## Grafana,Prometheus creation pending completion"
kubectl wait --for condition=available --timeout=300s deployment -l "app in (grafana,prometheus)"
}

function create_ingress(){
echo "## Ingress deployed for Ui,Api,Explorer and Grafana"
echo
echo "## Lets Encrypt issuer deployed"
echo
echo "## Frontend Host: http://hlf-k8.tk"
echo
echo "## Backend Host: http://api.hlf-k8.tk"
echo
echo "## Hyperledger Explorer Host: http://explorer.hlf-k8.tk"
echo "## Username: admin"
echo "## Password: adminpw"
echo
echo "## Grafana Host: http://grafana.hlf-k8.tk"
echo "## Username: admin"
echo "## Password: adminpw"
echo
kubectl apply -f ingress/
}

# Let's go ###################################################################################
create_pv
create_pvc
create_kafka
create_monitoring_tool
create_fabric_ca_server
create_certificates
create_artifacts
create_orderer
create_peer
create_app_channel
join_app_channel
update_anchor_peer
# package_chaincode
install_chaincode
deploy_chaincode
approve_chaincode
check_commit_readness
commit_chaincode
# create_connection_json
init_ledger_data
create_connection_profile
create_api
create_ui
create_explorer
create_ingress