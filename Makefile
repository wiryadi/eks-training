SHELL := /bin/bash

#check prerequisite
CHECK_AWS_CLI := $(shell command -v aws 2> /dev/null)
CHECK_AWS_IAM_AUTHENTICATOR := $(shell command -v aws-iam-authenticator 2> /dev/null)

#CONFIGURABLE
CLUSTER_NAME := "eks-training"
AMI := "ami-09e4ca02af4c6ddf5"
KUBECONFIG_FILE := output/${CLUSTER_NAME}.kubeconfig
PEM_KEY_NAME := ${CLUSTER_NAME}
PEM_KEY_FILE := output/${CLUSTER_NAME}.pem

#CFN Parameters definition
CLUSTER_PARAMS := 'ParameterKey=ClusterName,ParameterValue=${CLUSTER_NAME}'
NODE_PARAMS := 'ParameterKey=ClusterName,ParameterValue=${CLUSTER_NAME} ParameterKey=NodeImageId,ParameterValue=${AMI} ParameterKey=KeyName,ParameterValue=${PEM_KEY_NAME}'


.PHONY: verify create_all create_vpc create_iam create_cluster create_kube_config create_keypair\
delete_all delete_vpc delete_iam delete_cluster delete_keypair

verify:
ifndef CHECK_AWS_CLI
	$(error "aws cli is not installed.")
else
	$(info "OK. aws cli detected")
endif
ifndef CHECK_AWS_IAM_AUTHENTICATOR
	$(error "aws iam authenticator is not installed.")
else
	$(info "OK. aws iam authenticator detected")
endif

setup:
	mkdir -p temp && mkdir -p output

create_all: create_cluster create_nodes create_kube_config

create_cluster: create_iam create_vpc
	bash/apply-cfn.sh eks-cluster cloudformation/eks-cluster.yaml ${CLUSTER_PARAMS}

create_kube_config: setup create_cluster clean
	bash/create-kubeconfig.sh ${CLUSTER_NAME} ${KUBECONFIG_FILE}

create_nodes: setup clean create_keypair create_cluster
	bash/apply-cfn.sh eks-node-group cloudformation/eks-node-group.yaml ${NODE_PARAMS} CAPABILITY_IAM
	bash/onboard-node-group.sh eks-node-group ${KUBECONFIG_FILE}

create_keypair: setup clean
	bash/create-keypair.sh ${PEM_KEY_NAME} ${PEM_KEY_FILE}

create_iam:
	bash/apply-cfn.sh eks-iam cloudformation/eks-iam.yaml N CAPABILITY_IAM

create_vpc:
	bash/apply-cfn.sh eks-vpc cloudformation/eks-vpc.yaml


delete_all: delete_vpc delete_iam clean

delete_vpc: delete_cluster clean
	bash/delete-cfn.sh eks-vpc

delete_iam: delete_cluster clean
	bash/delete-cfn.sh eks-iam

delete_cluster: delete_nodes
	bash/delete-cfn.sh eks-cluster

delete_nodes: clean
	bash/delete-cfn.sh eks-node-group

clean:
	rm -rf temp/*