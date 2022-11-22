#!/usr/bin/env bash
#
MY_APPLICATION=$1
#
# Step_3 : Run Defined Job via YAML file
#
# helm uninstall spark-operator
#
# Step 3 Dummy
if [ -z $MY_APPLICATION ]; then
   ./spark/run-spark-pi-2k8s-pods
   #./spark/run-pyspark-pi-2k8s-pods
   echo "Execute spark-pi application! SparkDriver K8S logs! "
else
   cd jobs
   ./run-pyspark-jobs-2k8s-pods ${MY_APPLICATION}
   echo "execute application  : ~ $ ./jobs/${MY_APPLICATION}.yaml  ==> SparkDriver K8S logs! "
fi
