#!/bin/bash

VERSION=1.9.4
NAMESPACE=istio-system


# Functions #########################################################################

prepare_istio(){
sudo mkdir $HOME/istio
sudo chown ${USER} -R $HOME/istio
kubectl create ns ${NAMESPACE}
}

install_istioctl(){
echo
echo "Istioctl - install"
curl -sL "https://github.com/istio/istio/releases/download/$VERSION/istio-$VERSION-linux-amd64.tar.gz" | tar xz
sudo mv istio-$VERSION/bin/istioctl /usr/local/bin/istioctl
sudo chmod +x /usr/local/bin/istioctl
sudo mv istio-$VERSION/tools/istioctl.bash $HOME/istio/istioctl.bash
sudo mv istio-$VERSION/samples/addons $HOME/istio/addons
sudo mv istio-$VERSION/samples/bookinfo $HOME/istio/bookinfo
sudo rm -rf istio-$VERSION
}

enable_istioctl_autocompletion(){
echo "source $HOME/istio/istioctl.bash" >>~/.bashrc
}

install_istio_operator(){
echo
echo "Istio operator - install"
istioctl operator init
}

list_istio_profile(){
echo
echo "Istio profiles"
istioctl profile list
}

create_custom_profile(){
echo "Custom Profile"
echo "
apiVersion: install.istio.io/v1alpha1
kind: IstioOperator
metadata:
  name: istio-cp
spec:
  profile: default
  components:
    egressGateways:
    - name: istio-egressgateway
      enabled: true
"> $HOME/istio/istio_default.yaml
}

install_istio(){
  kubectl -n ${NAMESPACE} apply -f $HOME/istio/istio_default.yaml
}

install_addons(){
  kubectl apply -f $HOME/istio/addons
  kubectl -n ${NAMESPACE} rollout status deployment/kiali
}


# Let's go ###################################################################################
prepare_istio
install_istioctl
enable_istioctl_autocompletion
install_istio_operator
list_istio_profile
create_custom_profile
install_istio
install_addons


