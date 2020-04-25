#!/usr/bin/env bash
#Parameters
# $1: stack name

aws cloudformation describe-stacks --stack-name $1 > /dev/null 2>&1
if [[ $? == 0 ]]
then
  echo about to delete $1
  aws cloudformation delete-stack  --stack-name $1
  echo waiting ...
  aws cloudformation wait stack-delete-complete --stack-name $1
  echo $1 was successfully deleted
else
  echo unable to find $1. exiting.
fi
