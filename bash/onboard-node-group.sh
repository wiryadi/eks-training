#!/usr/bin/env bash

#Parameters
# $1: nodegroup stack name
# $2: kubeconfig

export role_arn=$(aws cloudformation describe-stacks --stack-name ${1} --query "Stacks[0].Outputs[?OutputKey=='NodeInstanceRole'].OutputValue" --output text)
envsubst < templates/aws-auth-cm.yaml.templates > temp/aws-auth-cm.yaml

KUBECONFIG=$2 kubectl apply -f temp/aws-auth-cm.yaml
