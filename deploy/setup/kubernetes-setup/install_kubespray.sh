#!/bin/bash

# Variables ########################################

IP_HAPROXY=$(dig +short elb.kub)
KUBESPRAY_VERSION=2.15
KUBESPRAY_PATH=${HOME}/kubespray
SSH_PASSWORD=vagrant
HELM_ENABLED=true
METRIC_SERVER_ENABLED=true
METALLB_ENABLED=true
METALLB_IP_RANGE=192.168.12.240-192.168.12.250
NGINX_INGRESS_ENABLED=true
HAPROXY_ENABLED=true
WEAVE_ENABLED=true
AUTH_ENABLED=true

# Functions ########################################

prepare_kubespray(){
echo
echo "## 1. Git clone kubespray"
git clone https://github.com/kubernetes-sigs/kubespray.git ${KUBESPRAY_PATH}
cd ${KUBESPRAY_PATH}
git branch -a | grep release
git checkout release-${KUBESPRAY_VERSION}
sudo chown -R ${USER} ${KUBESPRAY_PATH}

echo
echo "## 2. Install requirements"
sudo pip3 install --quiet -r requirements.txt

echo
echo "## 3. ANSIBLE | copy sample inventory"
cp -rfp inventory/sample inventory/mykub
rm inventory/mykub/inventory.ini
touch inventory/mykub/inventory.ini

echo
echo "## 4. ANSIBLE | change inventory"
echo "[all]">>inventory/mykub/inventory.ini
cat /etc/hosts | grep k8sm | grep -v 127.0 | awk '{print $2" ansible_host="$1" ip="$1}'>>inventory/mykub/inventory.ini
cat /etc/hosts | grep k8sn | grep -v 127.0 | awk '{print $2" ansible_host="$1" ip="$1}'>>inventory/mykub/inventory.ini

echo "[kube-master]">>inventory/mykub/inventory.ini
cat /etc/hosts | grep k8sm | grep -v 127.0 | awk '{print $2}'>>inventory/mykub/inventory.ini

echo "[etcd]">>inventory/mykub/inventory.ini
cat /etc/hosts | grep k8sm | grep -v 127.0 | awk '{print $2}'>>inventory/mykub/inventory.ini

echo "[kube-node]">>inventory/mykub/inventory.ini
cat /etc/hosts | grep k8sn | grep -v 127.0 | awk '{print $2}'>>inventory/mykub/inventory.ini
check_nodes=`cat /etc/hosts | grep k8sn | grep -v 127.0`
if [ -z "$check_nodes" ]
then
cat /etc/hosts | grep k8sm | grep -v 127.0 | awk '{print $2}'>>inventory/mykub/inventory.ini
fi

echo "[calico-rr]">>inventory/mykub/inventory.ini
echo "[k8s-cluster:children]">>inventory/mykub/inventory.ini
echo "kube-master">>inventory/mykub/inventory.ini
echo "kube-node">>inventory/mykub/inventory.ini
echo "calico-rr">>inventory/mykub/inventory.ini

if [ "$HELM_ENABLED" == true ]
then
echo
echo "## Helm"
sed -i s/"helm_enabled: false"/"helm_enabled: true"/g inventory/mykub/group_vars/k8s-cluster/addons.yml
fi

if [ "$METRIC_SERVER_ENABLED" == true ]
then
echo
echo "## Metric Server"
sed -i s/"# kube_read_only_port"/"kube_read_only_port"/g inventory/mykub/group_vars/k8s-cluster/addons.yml
sed -i s/"metrics_server_enabled: false"/"metrics_server_enabled: true"/g inventory/mykub/group_vars/k8s-cluster/addons.yml
fi

if [ "$METALLB_ENABLED" == true ]
then
echo
echo "## MetalLB"
sed -i s/"kube_proxy_strict_arp: false"/"kube_proxy_strict_arp: true"/g inventory/mykub/group_vars/k8s-cluster/k8s-cluster.yml
sed -i s/"metallb_enabled: false"/"metallb_enabled: true"/g inventory/mykub/group_vars/k8s-cluster/addons.yml
sed -i s/"# metallb_ip_range"/"metallb_ip_range"/g inventory/mykub/group_vars/k8s-cluster/addons.yml
sed -i s/"#   - \"10.5.0.50-10.5.0.99\""/"  - \"${METALLB_IP_RANGE}\""/g inventory/mykub/group_vars/k8s-cluster/addons.yml
sed -i s/"# metallb_protocol: \"layer2\""/"metallb_protocol: \"layer2\""/g inventory/mykub/group_vars/k8s-cluster/addons.yml
fi

if [ "$NGINX_INGRESS_ENABLED" == true ]
then
echo
echo "## Nginx Ingress Controller"
sed -i s/"ingress_nginx_enabled: false"/"ingress_nginx_enabled: true"/g inventory/mykub/group_vars/k8s-cluster/addons.yml
sed -i s/"# ingress_nginx_host_network: false"/"ingress_nginx_host_network: true"/g inventory/mykub/group_vars/k8s-cluster/addons.yml
sed -i s/"# ingress_nginx_nodeselector:"/"ingress_nginx_nodeselector:"/g inventory/mykub/group_vars/k8s-cluster/addons.yml
sed -i s/"#   kubernetes.io\/os: \"linux\""/"  kubernetes.io\/os: \"linux\""/g inventory/mykub/group_vars/k8s-cluster/addons.yml
sed -i s/"# ingress_nginx_namespace: \"ingress-nginx\""/"ingress_nginx_namespace: \"ingress-nginx\""/g inventory/mykub/group_vars/k8s-cluster/addons.yml
sed -i s/"# ingress_nginx_insecure_port: 80"/"ingress_nginx_insecure_port: 80"/g inventory/mykub/group_vars/k8s-cluster/addons.yml
sed -i s/"# ingress_nginx_secure_port: 443"/"ingress_nginx_secure_port: 443"/g inventory/mykub/group_vars/k8s-cluster/addons.yml
fi

if [ "$HAPROXY_ENABLED" == true ]
then
echo
echo "## 5.x ANSIBLE | active external LB"
sed -i s/"## apiserver_loadbalancer_domain_name: \"elb.some.domain\""/"apiserver_loadbalancer_domain_name: \"elb.kub\""/g inventory/mykub/group_vars/all/all.yml
sed -i s/"# loadbalancer_apiserver:"/"loadbalancer_apiserver:"/g inventory/mykub/group_vars/all/all.yml
sed -i s/"#   address: 1.2.3.4"/"  address: ${IP_HAPROXY}"/g inventory/mykub/group_vars/all/all.yml
sed -i s/"#   port: 1234"/"  port: 6443"/g inventory/mykub/group_vars/all/all.yml
fi

if [ "$WEAVE_ENABLED" == true ]
then
echo
echo "## Weave CNI"
sed -i s/"kube_network_plugin: calico"/"kube_network_plugin: weave"/g inventory/mykub/group_vars/k8s-cluster/k8s-cluster.yml
export WEAVE_PASSWORD=$(date +%s | sha256sum | base64 | head -c 32 ; echo)
sed -i s/"# weave_password: ~"/"weave_password: $WEAVE_PASSWORD"/g inventory/mykub/group_vars/k8s-cluster/k8s-net-weave.yml
fi

if [ "$AUTH_ENABLED" == true ]
then
echo
echo "## Basic auth and token auth enabled"
sed -i s/"# kube_basic_auth: false"/"kube_basic_auth: true"/g inventory/mykub/group_vars/k8s-cluster/k8s-cluster.yml
sed -i s/"# kube_token_auth: false"/"kube_token_auth: true"/g inventory/mykub/group_vars/k8s-cluster/k8s-cluster.yml
fi
}

create_ssh_for_kubespray(){
echo
echo "## 6. SSH | ssh private key and push public key"
sudo -u ${USER} bash -c "ssh-keygen -b 2048 -t rsa -f ${HOME}/.ssh/id_rsa -q -N ''"
for srv in $(cat /etc/hosts | grep k8s | awk '{print $2}');do
cat ${HOME}/.ssh/id_rsa.pub | sshpass -p ${SSH_PASSWORD} ssh -o StrictHostKeyChecking=no ${USER}@$srv -T 'tee -a >> ${HOME}/.ssh/authorized_keys'
done
}

run_kubespray(){
echo
echo "## 7. ANSIBLE | Run kubespray"
sudo su - ${USER} bash -c "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i ${KUBESPRAY_PATH}/inventory/mykub/inventory.ini -b -u ${USER} ${KUBESPRAY_PATH}/cluster.yml"
}

copy_cert_for_kubectl(){
echo
mkdir -p ${HOME}/.kube
sudo chown -R ${USER} ${HOME}/.kube
echo
echo "## 9. KUBECTL | copy cert"
sudo cat /etc/kubernetes/admin.conf >${HOME}/.kube/config
sudo chmod 600 ${HOME}/.kube/config
sudo usermod -aG docker $USER
}

enable_kubectl_autocompletion(){
echo 'source <(kubectl completion bash)' >>~/.bashrc
kubectl completion bash | sudo tee /etc/bash_completion.d/kubectl
echo 'alias k=kubectl' >>~/.bashrc
echo 'complete -F __start_kubectl k' >>~/.bashrc
echo
echo "## kubectl auto completion enabled"
}

enable_helm_autocompletion(){
echo 'source <(helm completion bash)' >>~/.bashrc
echo
echo "## helm auto completion enabled"
}

# Let's Go!! ########################################
prepare_kubespray
create_ssh_for_kubespray
run_kubespray
copy_cert_for_kubectl
enable_kubectl_autocompletion
if [ "$HELM_ENABLED" == true ]
then
echo
enable_helm_autocompletion
fi
