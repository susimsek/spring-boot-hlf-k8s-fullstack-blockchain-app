#!/bin/bash


# Functions #########################################################################


function uninstall(){
echo "## Uninstalled app"
kubectl delete -f explorer/
kubectl delete -f ui/
kubectl delete -f api/
kubectl delete -f job
kubectl delete -f cc/
kubectl delete -f peer/org3/
kubectl delete -f peer/org2/
kubectl delete -f peer/org1/
kubectl delete -f peer/
kubectl delete -f orderer/
kubectl delete -f ca/
kubectl delete -f kafka/
}

# Let's go ###################################################################################
uninstall