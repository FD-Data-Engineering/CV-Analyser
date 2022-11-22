#!/bin/bash
##
set -e

HADOOP_VER=3.2.1
REPO_NAME=jpacerqueira83

# Build docker image.
docker build --build-arg HADOOP_VERSION=$HADOOP_VER -t  local-$REPO_NAME/hadoop-k8s:$HADOOP_VER  -f ./hadoop.Dockerfile .

# Push to docker repository.
docker tag local-$REPO_NAME/hadoop-k8s:$HADOOP_VER $REPO_NAME/hadoop-k8s:$HADOOP_VER
docker push $REPO_NAME/hadoop-k8s:$HADOOP_VER
#
