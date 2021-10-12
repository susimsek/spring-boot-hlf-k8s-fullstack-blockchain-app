#!/bin/bash

NFS_DIR=/srv/kubedata
TARGET_PATH=$NFS_DIR/fabricfiles
FABRIC_FILES_PATH=/vagrant/k8s/fabricfiles

# Functions #########################################################################

function copy_fabricfiles(){
echo "## Copied fabric files"    
echo
sudo cp -a $FABRIC_FILES_PATH/. $TARGET_PATH/
sudo chmod -R 777 $TARGET_PATH/
}

# Let's go ###################################################################################
copy_fabricfiles