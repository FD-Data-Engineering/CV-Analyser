#!/usr/bin/env bash
#
OPER=$1
#
# Step_1 : Install spark-operator in kubernetes
# Step_2 : For spark-operator enable webhook
# Step_3 : Run Defined Job via YAML file
#
# helm uninstall spark-operator
#
./spark/install-spark-kubernetes-operator
./spark/create-spark-service-account
#
# Step 3 Dummy
if [[ $OPER == "1" ]]; then
   ./spark/run-spark-pi-2k8s-pods
   #./spark/run-pyspark-pi-2k8s-pods
   echo "Setup done! Look into K8S logs for pyspark-pi application"
else
   echo "Setup done! execute your own application via : ~ $ ./execute-k8s-spark-workload.sh MY_APPLICATION.yaml  "
fi
