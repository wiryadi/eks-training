#!/usr/bin/env bash

#parameters:
# $1 EKS-cluster name
# $2 output kubeconfig file
#output:
# kubeconfig file will be created under output folder

cluster_name=$1
config_file=$2

#archive existing config file
if [[ -f $config_file ]]; then
  mv $config_file ${config_file}.$(date +"%Y%m%d_%H%M%S")
fi

aws eks update-kubeconfig --name ${cluster_name} --kubeconfig $config_file