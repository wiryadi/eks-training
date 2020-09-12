#!/usr/bin/env bash

#Parameters
# $1: kubeconfig

echo Creating GP2 EBS Storage Class
KUBECONFIG=$1 kubectl create -f k8s-manifest/gp2-storage-class.yaml
RESULT_CODE=$?

if [[ RESULT_CODE == 0 ]]; then
  echo Successfully created GP2 storage class
else
  echo Failed to create GP2 storage class
fi

exit $RESULT_CODE
