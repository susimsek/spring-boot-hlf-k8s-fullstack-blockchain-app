#!/bin/bash

RELEASE_NAME=sonarqube
NAMESPACE=sonarqube-system
CHART_VERSION=9.6.4
POSTGRESQL_USER=sonar
POSTGRESQL_PASSWORD=sonar
POSTGRESQL_DATABASE=sonar
ADMIN_USER=admin
ADMIN_PASSWORD=root
URL_PREFIX=/sonarqube
HOSTNAME=sonarqube.info

# Functions #########################################################################

prepare_sonarqube(){
sudo mkdir $HOME/sonarqube
sudo chown ${USER} -R $HOME/sonarqube
kubectl create ns ${NAMESPACE}
}

add_helm_repo(){
helm repo add oteemocharts https://oteemo.github.io/charts
}

create_custom_values(){
echo "Custom Values"
echo "
replicaCount: 1
jdbcDatabaseType: postgresql
service:
  type: ClusterIP
  externalPort: 9000
postgresql:
  enabled: true
  postgresqlUsername: ${POSTGRESQL_USER}
  postgresqlPassword: ${POSTGRESQL_PASSWORD}
  postgresqlDatabase: ${POSTGRESQL_DATABASE}
ingress:
  enabled: true
  annotations:
    kubernetes.io/ingress.class: nginx
  tls: []
  hosts:
    - name: ${HOSTNAME}
      path: ${URL_PREFIX}
account:
  adminPassword: ${ADMIN_PASSWORD}
  currentAdminPassword: admin
sonarProperties:
  sonar.forceAuthentication: true
  sonar.web.context: ${URL_PREFIX}
readinessProbe:
  sonarWebContext: ${URL_PREFIX}/
livenessProbe:
  sonarWebContext: ${URL_PREFIX}/
"> $HOME/sonarqube/values.production.yaml
}

install_sonarqube(){
  helm install ${RELEASE_NAME} --namespace ${NAMESPACE} --version ${CHART_VERSION} oteemocharts/sonarqube -f $HOME/sonarqube/values.production.yaml
}


# Let's go ###################################################################################
prepare_sonarqube
add_helm_repo
create_custom_values
install_sonarqube