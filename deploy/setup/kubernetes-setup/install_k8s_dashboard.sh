#!/bin/bash

RELEASE_NAME=kubernetes-dashboard
NAMESPACE=kubernetes-dashboard
CHART_VERSION=4.0.3
HOSTNAME=kubernetes-dashboard.info
SERVICE_ACCOUNT_NAME=dashboard-admin

# Functions #########################################################################

prepare_kubernetes_dashboard(){
sudo mkdir $HOME/kubernetes_dashboard
sudo chown ${USER} -R $HOME/kubernetes_dashboard
kubectl create ns ${NAMESPACE}
}

add_helm_repo(){
helm repo add kubernetes-dashboard https://kubernetes.github.io/dashboard/
}

create_rbac(){

echo "KUBECTL | create RBAC"
# shellcheck disable=SC2016
echo "
apiVersion: v1
kind: ServiceAccount
metadata:
  name: ${SERVICE_ACCOUNT_NAME}
  namespace: ${NAMESPACE}
---
kind: ClusterRoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: ${SERVICE_ACCOUNT_NAME}-clusterrolebinding
subjects:
- kind: ServiceAccount
  name: ${SERVICE_ACCOUNT_NAME}
  apiGroup: \"\"
  namespace: ${NAMESPACE}
roleRef:
  kind: ClusterRole
  name: cluster-admin
  apiGroup: \"\"
"> $HOME/kubernetes_dashboard/rbac.yaml

kubectl apply -f $HOME/kubernetes_dashboard/rbac.yaml

}

create_custom_values(){

echo "Custom Values"
echo "
replicaCount: 1
enableInsecureLogin: false
ingress:
  enabled: true
  annotations:
    kubernetes.io/ingress.class: nginx
  paths:
    - /
  hosts:
    - ${HOSTNAME}
"> $HOME/kubernetes_dashboard/values.production.yaml
}

install_kubernetes_dashboard(){
  helm install ${RELEASE_NAME} --namespace ${NAMESPACE} --version ${CHART_VERSION} kubernetes-dashboard/kubernetes-dashboard -f $HOME/kubernetes_dashboard/values.production.yaml
}

get_dashboard-admin_token(){
  token_secret_name="$(kubectl -n ${NAMESPACE} get serviceaccount ${SERVICE_ACCOUNT_NAME} -o=jsonpath='{.secrets[0].name}')"
  token="$(kubectl -n ${NAMESPACE} get secret ${token_secret_name} -ojsonpath='{.data.token}' | base64 --decode)"
  echo "Admin Token : ${token}"
}


# Let's go ###################################################################################
prepare_kubernetes_dashboard
add_helm_repo
create_rbac
create_custom_values
install_kubernetes_dashboard
get_dashboard-admin_token