#!/usr/bin/env bash
#parameters:
# $1 keypair name
# $2 private key file path

key_name=$1
private_key=$2

#archive existing config file
if [[ -f $private_key ]]; then
  chmod +w $private_key
  mv $private_key ${private_key}.$(date +"%Y%m%d_%H%M%S")
fi

aws ec2 create-key-pair --key-name $key_name --query 'KeyMaterial' --output text > $private_key
chmod 400 $private_key