#!/bin/bash

RELEASE_NAME=cert-manager
NAMESPACE=cert-manager
CHART_VERSION=v1.4.0
LETSENCRYPT_EMAIL=suaybsimsek58@gmail.com
HTTP01_INGRESS_CLASS=nginx

# Functions #########################################################################

prepare_cert_manager(){
sudo mkdir $HOME/cert_manager
sudo chown ${USER} -R $HOME/cert_manager
kubectl create ns ${NAMESPACE}
}

disable_resource_validation(){
kubectl label namespace ${NAMESPACE} certmanager.k8s.io/disable-validation=true
}

add_helm_repo(){
helm repo add jetstack https://charts.jetstack.io
}

create_custom_values(){

echo "Custom Values"
echo "
replicaCount: 1
installCRDs: true
"> $HOME/cert_manager/values.production.yaml
}

install_letsencrypt_issuer(){
echo "Cluster Issuer"
echo "
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-prod
spec:
  acme:
    email: ${LETSENCRYPT_EMAIL}
    server: https://acme-staging-v02.api.letsencrypt.org/directory
    privateKeySecretRef:
      name: letsencrypt-prod
    solvers:
    - http01:
        ingress:
          class: ${HTTP01_INGRESS_CLASS}
"> $HOME/cert_manager/cluster-issuer-prod.yaml

sleep 20
kubectl apply -f $HOME/cert_manager/cluster-issuer-prod.yaml
}

install_cert_manager(){
  helm install ${RELEASE_NAME} --wait --timeout 60s --namespace ${NAMESPACE} --version ${CHART_VERSION} jetstack/cert-manager -f $HOME/cert_manager/values.production.yaml
}


# Let's go ###################################################################################
prepare_cert_manager
disable_resource_validation
add_helm_repo
create_custom_values
install_cert_manager
install_letsencrypt_issuer