while [ $# -gt 0 ]; do
  case "$1" in
    --cc_name=*)
      CHAINCODE_NAME="${1#*=}"
      ;;
    --cc_org1=*)
      CC_ORG1="${1#*=}"
      ;;
    --cc_org2=*)
      CC_ORG2="${1#*=}"
      ;;
    --cc_org3=*)
      CC_ORG3="${1#*=}"
      ;;
    *)
      printf "***************************\n"
      printf "* Error: Invalid argument.*\n"
      printf "***************************\n"
      exit 1
  esac
  shift
done

CC_PATH=/chaincode/$CHAINCODE_NAME

create_connection_json(){
mkdir -p $CC_PATH/packaging
cd $CC_PATH/packaging
json='{
            "address": "'$CC_ORG1'",
            "dial_timeout": "10s",
            "tls_required": false,
            "client_auth_required": false,
            "client_key": "-----BEGIN EC PRIVATE KEY----- ... -----END EC PRIVATE KEY-----",
            "client_cert": "-----BEGIN CERTIFICATE----- ... -----END CERTIFICATE-----",
            "root_cert": "-----BEGIN CERTIFICATE---- ... -----END CERTIFICATE-----"
        }'
echo $json > connection.json
}

create_metadata_json(){
json='{
          "path":"","type":"external","label":"'$CHAINCODE_NAME'"
      }'
echo $json > metadata.json
}

package_chaincode(){
package basic-org1.tgz
sed -i "s/$CC_ORG1/$CC_ORG2/g" connection.json
package basic-org2.tgz
sed -i "s/$CC_ORG2/$CC_ORG3/g" connection.json
package basic-org3.tgz
}

package(){
tar_name="$1"
tar cfz code.tar.gz connection.json
tar cfz $tar_name code.tar.gz metadata.json
rm code.tar.gz
}

# Let's go ###################################################################################
create_connection_json
create_metadata_json
package_chaincode