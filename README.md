# Spark on Kubernetes using Spark-Operator

## Local Developement Pre-Requisite
The below steps should help a user to get started:

* Docker Desktop
Ensure Docker Desktop is installed on your local machine. This can be downloaded [here](https://docs.docker.com/desktop/install/windows-install/)
* Enabling Docker support in WSL 2 distros
Consigure WSL 2 as a backend for Kubernetes in Docker desktop using this [link](https://learn.microsoft.com/en-us/windows/wsl/install)
* Kubernetes
After installing Docker desktop, enable Kubernetes to run on your local machine by following these [steps](https://docs.docker.com/desktop/windows/wsl/)
The above steps will install `` kubectl ``. You can test this by running ``  kubectl get nodes ``. This command will display the nodes you have on your local machine.

## Spark Operator
First we need to create the spark-operator namespace by running `` kubectl create namespace spark-operator ``.

Next we have to create a service account with some RBAC elevated privileges. We do this by running
`` kubectl apply -f ./manifest/spark-rbac.yaml `` 

## Helm Install
With the ecosystem configured for spark operator, we can proceed to installing Helm. Helm is a package manager used to manage Kubernetes application. In this project, we are using Helm v3.
Run the below commands to install and configure Helm on your local machine.
```
       curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
       chmod 700 get_helm.sh
       ./get_helm.sh
```

After installing Helm, run the following commands to add the helm incumbator repository.
```    helm repo add incubator https://charts.helm.sh/incubator
       helm repo add spark-operator https://googlecloudplatform.github.io/spark-on-k8s-operator
```

Next, we run helm install with some helm config to deploy cv-analyser. The command to run is:
``` 
       helm install cv-analyser spark-operator/spark-operator --namespace spark-operator  --set sparkJobNamespace=spark-operator --set webhook.enable=true 
```
The above command will take a while to setup. When it is completed, run ``` kubectl get all -n spark-operator ``` to confirm the cv-analyser deployment. 

## Deploying Spark App on Kubernetes
With the infrastructure now setup, we can now deploy the spark jobs on Kubernetes.

## Test - Running a PySpark app
The examples directory contains Spark Operator job definitions you can use:
* spark-pi.yaml
* spark-py-pi.yaml
You can run these with ```kubectl ``` by executing:
``` 
       kubectl apply -f ./examples/spark-pi.yaml 
       kubectl apply -f ./examples/spark-py-pi.yaml
```
Upon completion, you can inspect the pods by running ``` kubectl get pods -n spark-operator ``` to list all pods in spark-operator namespace.

And if you check the logs by running ```kubectl logs pyspark-pi-driver -n spark-operator``` you should find one line in the logs giving an approximate value of ```pi Pi is roughly 3.142020```.

## Deploying CV Analyser Spark Jobs on Kubernetes

The CV Analyser jobs can be found in ``` /jobs/job-dir ```. 


