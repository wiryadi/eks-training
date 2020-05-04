#!/usr/bin/env bash
#parameters:
# $1 keypair name

key_name=$1

aws ec2 delete-key-pair --key-name $key_name
