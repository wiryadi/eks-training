#!/usr/bin/env bash

#parameters:
# $1 EKS-cluster stack name
# output $cluster_name.kubeconfig
cluster_name=$(aws cloudformation describe-stacks --stack-name ${1} --query "Stacks[0].Outputs[?OutputKey=='EksClusterName'].OutputValue" --output text)
aws eks update-kubeconfig --name ${cluster_name} --kubeconfig ${cluster_name}.kubeconfig