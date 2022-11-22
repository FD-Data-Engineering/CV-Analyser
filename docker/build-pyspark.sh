#!/bin/bash
##
set -e

SPARK_BUILD_VER=2.4.5
REPO_NAME=jpacerqueira83

# Build docker image.
docker build -t local-$REPO_NAME/pyspark-k8s:$SPARK_BUILD_VER -f ./pyspark.Dockerfile .

# Push to docker repository.
docker tag local-$REPO_NAME/pyspark-k8s:$SPARK_BUILD_VER $REPO_NAME/pyspark-k8s:$SPARK_BUILD_VER 
docker push $REPO_NAME/pyspark-k8s:$SPARK_BUILD_VER
#
