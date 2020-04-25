SHELL := /bin/bash

#check prerequisite
CHECK_AWS_CLI := $(shell command -v aws 2> /dev/null)
CHECK_AWS_IAM_AUTHENTICATOR := $(shell command -v aws-iam-authenticator 2> /dev/null)

#Parameters definition
CLUSTER_NAME := "eks-training"
AMI := "ami-09e4ca02af4c6ddf5"
CLUSTER_PARAMS := 'ParameterKey=ClusterName,ParameterValue=${CLUSTER_NAME}'
NODE_PARAMS := 'ParameterKey=ClusterName,ParameterValue=${CLUSTER_NAME} ParameterKey=NodeImageId,ParameterValue=${AMI}'
.PHONY: verify create_all create_vpc create_iam create_cluster create_kube_config\
delete_all delete_vpc delete_iam delete_cluster

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

create_all: create_cluster create_nodes create_kube_config
	#place holder

create_cluster: create_iam create_vpc
	bash/apply-cfn.sh eks-cluster cloudformation/eks-cluster.yaml ${CLUSTER_PARAMS}

create_kube_config: create_cluster
	bash/create-kubeconfig.sh eks-cluster

create_nodes:
	bash/apply-cfn.sh eks-node-groups cloudformation/eks-mixed-node-group.yaml ${NODE_PARAMS} CAPABILITY_IAM

create_iam:
	bash/apply-cfn.sh eks-iam cloudformation/eks-iam.yaml N CAPABILITY_IAM

create_vpc:
	bash/apply-cfn.sh eks-vpc cloudformation/eks-vpc.yaml

delete_all: delete_vpc delete_iam

delete_vpc: delete_cluster
	bash/delete-cfn.sh eks-vpc

delete_iam: delete_cluster
	bash/delete-cfn.sh eks-iam

delete_cluster: delete_nodes
	bash/delete-cfn.sh eks-cluster

delete_nodes:
	bash/delete-cfn.sh eks-node-groups