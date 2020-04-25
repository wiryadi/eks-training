#!/usr/bin/env bash
#Parameters
# $1: stack name
# $2: cfn yaml
# $3: parameters. N to bypass
# $4: capabilities. N to bypass

if [[ -n "$3" && "$3" != "N" ]]; then parameters="--parameters $3"; else parameters=""; fi
if [[ -n "$4" && "$4" != "N" ]]; then capabilities="--capabilities $4"; else capabilities=""; fi

aws cloudformation describe-stacks --stack-name $1 > /dev/null 2>&1
if [[ $? == 0 ]]
then
  echo stack $1 already exist, nothing to do
#uncomment below to force update
#  aws cloudformation update-stack --stack-name $1 --template-body file://$2 ${parameters} ${capabilities}
#  aws cloudformation wait stack-update-complete --stack-name $1
else
  aws cloudformation create-stack  --stack-name $1 --template-body file://$2 ${parameters} ${capabilities}
  echo waiting ...
  aws cloudformation wait stack-create-complete --stack-name $1
  echo $1 was successfully created
fi