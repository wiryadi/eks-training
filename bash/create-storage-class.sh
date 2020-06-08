#!/usr/bin/env bash

#Parameters
# $1: kubeconfig

echo Creating GP2 EBS Storage Class
KUBECONFIG=$1 kubectl apply -f temp/aws-auth-cm.yaml
RESULT_CODE=$?

if [[ RESULT_CODE == 0 ]]; then
  echo Successfully created GP2 storage class
else
  echo Failed to create GP2 storage class
fi

exit $RESULT_CODE
