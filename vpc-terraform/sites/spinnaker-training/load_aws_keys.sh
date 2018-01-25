#!/bin/bash

if [ ! -f  ~/.aws/credentials ] ; then
   echo "ERROR: File  ~/.aws/credentials does not exist"
   exit 
fi

TF_VAR_access_key=$(cat ~/.aws/credentials | grep aws_access_key | awk -F= '{ print $2}')
TF_VAR_secret_key=$(cat ~/.aws/credentials | grep aws_secret_access_key | awk -F= '{ print $2}')
export TF_VAR_access_key
export TF_VAR_secret_key
echo "Variables exported successfully"
