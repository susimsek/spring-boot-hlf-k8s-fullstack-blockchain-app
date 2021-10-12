#!/bin/bash

RELEASE_NAME=jenkins
NAMESPACE=jenkins-system
CHART_VERSION=3.3.9
ADMIN_USER=admin
ADMIN_PASSWORD=root
URL_PREFIX=/jenkins
HOSTNAME=jenkins.info
SERVICE_ACCOUNT_NAME=jenkins

# Functions #########################################################################

prepare_jenkins(){
sudo mkdir $HOME/jenkins
sudo chown ${USER} -R $HOME/jenkins
kubectl create ns ${NAMESPACE}
}

add_helm_repo(){
helm repo add jenkins https://charts.jenkins.io
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
"> $HOME/jenkins/rbac.yaml

kubectl apply -f $HOME/jenkins/rbac.yaml

}

create_custom_values(){

echo "Custom Values"
echo "
serviceAccount:
  create: false
  name: ${SERVICE_ACCOUNT_NAME}
serviceAccountAgent:
  create: false
  name: ${SERVICE_ACCOUNT_NAME}
agent:
  resources:
    requests:
      cpu: 512m
      memory: 512Mi
    limits:
      cpu: 512m
      memory: 512Mi
controller:
  adminUser: ${ADMIN_USER}
  adminPassword: ${ADMIN_PASSWORD}
  numExecutors: 5
  servicePort: 8080
  jenkinsUriPrefix: ${URL_PREFIX}
  serviceType: ClusterIP
  ingress:
    enabled: true
    annotations:
      kubernetes.io/ingress.class: nginx
    hostName: ${HOSTNAME}
    path: ${URL_PREFIX}
  installPlugins:
    - kubernetes:1.29.4
    - workflow-job:2.40
    - workflow-aggregator:2.6
    - credentials-binding:1.24
    - git:4.7.1
    - command-launcher:1.5
    - github-branch-source:2.10.2
    - pipeline-utility-steps:2.7.1
    - configuration-as-code:1.49
    - blueocean:1.24.6
    - kubernetes-cd:2.3.1
    - docker-workflow:1.26
  overwritePlugins: true
  resources:
    requests:
      cpu: 50m
      memory: 256Mi
    limits:
      cpu: 512m
      memory: 1048Mi
"> $HOME/jenkins/values.production.yaml
}

install_jenkins(){
  helm install ${RELEASE_NAME} --namespace ${NAMESPACE} --version ${CHART_VERSION} jenkins/jenkins -f $HOME/jenkins/values.production.yaml
}


# Let's go ###################################################################################
prepare_jenkins
add_helm_repo
create_rbac
create_custom_values
install_jenkins