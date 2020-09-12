#!/usr/bin/env bash
#Parameters
# $1: kubeconfig path
export KUBECONFIG=$1
export DASHBOARD_VERSION="v2.0.0"
export METRICS_VERSION="v0.3.6"

echo "Installing Kubernetes Dashboard"

kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/download/${METRICS_VERSION}/components.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/${DASHBOARD_VERSION}/aio/deploy/recommended.yaml

kubectl apply -f k8s-manifest/eks-admin-service-account.yaml

token=$(kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep eks-admin | awk '{print $1}'))

echo "To access Kubernetes Dashboard"
echo "kubectl proxy --port=8001 --address=0.0.0.0 --disable-filter=true &"
echo "http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/"