#!/bin/bash

IP_NFS=$(dig +short nfs.kub)
NFS_PATH=/srv/kubedata
RELEASE_NAME=nfs-provisioner
NAMESPACE=nfs-system
CHART_VERSION=4.0.10

kubectl_for_root(){
sudo mkdir /root/.kube
sudo cp /home/vagrant/.kube/config /root/.kube/
}

# Functions #########################################################################

prepare_nfs_provisioner(){
sudo mkdir $HOME/nfs_provisioner
sudo chown ${USER} -R $HOME/nfs_provisioner
kubectl create ns ${NAMESPACE}
}

add_helm_repo(){
helm repo add nfs-subdir-external-provisioner https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner/
}

create_custom_values(){

echo "Custom Values"
echo "
replicaCount: 1
image:
  pullPolicy: IfNotPresent
storageClass:
  name: nfs-client
  defaultClass: true
  archiveOnDelete: true
  accessModes: ReadWriteOnce
  reclaimPolicy: Delete
nfs:
  server: ${IP_NFS}
  path: ${NFS_PATH}

"> $HOME/nfs_provisioner/values.production.yaml
}

install_nfs_provisioner(){
  helm install ${RELEASE_NAME} --namespace ${NAMESPACE} --version ${CHART_VERSION} nfs-subdir-external-provisioner/nfs-subdir-external-provisioner -f $HOME/nfs_provisioner/values.production.yaml
}


# Let's go ###################################################################################
prepare_nfs_provisioner
add_helm_repo
create_custom_values
install_nfs_provisioner