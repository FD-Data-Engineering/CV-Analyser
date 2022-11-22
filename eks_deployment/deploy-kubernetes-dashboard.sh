#!/bin/bash
##
################################################################
## Deploy and Setup of Kubernetes Dashboard with Server Metrics
################################################################
set -e
#
echo "»Deploy Kubernetes Metrics Server"
wget -O v0.3.6.tar.gz https://codeload.github.com/kubernetes-sigs/metrics-server/tar.gz/v0.3.6 && tar -xzf v0.3.6.tar.gz
kubectl apply -f metrics-server-0.3.6/deploy/1.8+/
kubectl get deployment metrics-server -n kube-system
#
echo "Deploy Kubernetes DashBoard"
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0-beta8/aio/deploy/recommended.yaml
#
echo "start proxy http://127.0.0.1:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/ "
kubectl proxy
#
