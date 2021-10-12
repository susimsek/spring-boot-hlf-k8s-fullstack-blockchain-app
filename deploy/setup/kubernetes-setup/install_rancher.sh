#!/bin/bash

RELEASE_NAME=rancher
NAMESPACE=cattle-system
CHART_VERSION=2.5.8
LETSENCRYPT_EMAIL=suaybsimsek58@gmail.com
HOSTNAME=rancher.info

# Functions #########################################################################

prepare_rancher(){
sudo mkdir $HOME/rancher
sudo chown ${USER} -R $HOME/rancher
kubectl create ns ${NAMESPACE}
}

add_helm_repo(){
helm repo add rancher-latest https://releases.rancher.com/server-charts/latest
}

create_custom_values(){
echo "Custom Values"
echo "
replicas: 3
addLocal: true
hostname: ${HOSTNAME}
letsEncrypt:
  email: ${LETSENCRYPT_EMAIL}
  environment: production
ingress:
  extraAnnotations:
    kubernetes.io/ingress.class: nginx
  tls:
    source: rancher
"> $HOME/rancher/values.production.yaml
}

install_rancher(){
  helm install ${RELEASE_NAME} --namespace ${NAMESPACE} --version ${CHART_VERSION} rancher-latest/rancher -f $HOME/rancher/values.production.yaml
}


# Let's go ###################################################################################
prepare_rancher
add_helm_repo
create_custom_values
install_rancher