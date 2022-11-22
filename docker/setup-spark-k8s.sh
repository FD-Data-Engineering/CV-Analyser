#!/usr/bin/env bash
#
# build and load containers for 
# repo  https://hub.docker.com/repository/docker/jpacerqueira83/hadoop-k8s
# repo  https://hub.docker.com/repository/docker/jpacerqueira83/hive-k8s
# repo  https://hub.docker.com/repository/docker/jpacerqueira83/spark-k8s
# repo  https://hub.docker.com/repository/docker/jpacerqueira83/pyspark-k8s

# make sure user is authorized to register images under container register docker.io/jpacerqueira83/
docker login

./build-hadoop.sh
./build-hive.sh
./build-spark.sh
./build-pyspark.sh
#
