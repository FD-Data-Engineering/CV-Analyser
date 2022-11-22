#!/bin/bash
##
set -e

HIVE_BUILD_VER=3.1.2
REPO_NAME=jpacerqueira83

# Build docker image.
docker build --build-arg HIVE_VERSION=$HIVE_BUILD_VER -t local-$REPO_NAME/hive-k8s:$HIVE_BUILD_VER -f ./hive.Dockerfile .

# Push to docker repository.
docker tag local-$REPO_NAME/hive-k8s:$HIVE_BUILD_VER $REPO_NAME/hive-k8s:$HIVE_BUILD_VER
docker push $REPO_NAME/hive-k8s:$HIVE_BUILD_VER
#
