# Spark on Kubernetes using Spark-Operator

## Local Developement Pre-Requisites
The below steps should help a user to get started:

* Docker Desktop:
Ensure Docker Desktop is installed on your local machine. This can be downloaded [here](https://docs.docker.com/desktop/install/windows-install/)
* Enabling Docker support in WSL 2 distros:
Consigure WSL 2 as a backend for Kubernetes in Docker desktop using this [link](https://learn.microsoft.com/en-us/windows/wsl/install)
* Kubernetes
After installing Docker desktop, enable Kubernetes to run on your local machine by following these [steps](https://docs.docker.com/desktop/windows/wsl/)
The above steps will install `` kubectl ``. You can test this by running ``  kubectl get nodes ``. This command will display the nodes you have on your local machine.
* Installing Missing Packages:
If your WSL OS is UBuntu, run ``` .\install_package_dependencies.sh ``` to install all the dependencies needed to run the jobs. Otherwise, similar packages need to be installed based on other Linux flavours.
* Java:
Ensure Java 8 is installed on your local development machine. If not, the file can be downloaded from [here](https://fdplc.sharepoint.com/:u:/r/sites/CMCDataServices/Shared%20Documents/Data%20Engineering%20and%20Data%20Science/Packages/jdk-8u221-linux-x64.tar.gz?csf=1&web=1). You can install the file by executing
```   
       ./install-java.sh -f jdk-8u221-linux-x64.tar.gz
       export JAVA_HOME=/usr
```
* Python 3: Your local machine needs Python 3 to run the Spark jobs. Python 3 can be installed by following [this](https://docs.python-guide.org/starting/install3/linux/)

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
You can check mutating webhook configuration by running  ``` kubectl get mutatingwebhookconfiguration ``` . This should show you a similar result as above.

## Deploying Spark App on Kubernetes
With the infrastructure now setup, we can now deploy the spark jobs on Kubernetes.

## Test - Running a PySpark job
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

The CV Analyser Spark jobs can be found in ``` /jobs/job-dir ```. In that directory are two Python files: ``` load-data-cv-to-delta.py ``` and ``` dataminer-categorized-delta-analytics.py ```. The Kubernetes definitions can be found in ```/jobs ``` directory.
First and formost, run ``` load-data-cv-to-delta.yaml ``` to load the CV to create a ``.json`` file, which can be found in ``` /jobs/job-dir/data/raw_json ```.  
After, you can run ``` dataminer-categorized-delta-analytics.yaml ``` job, to analyse and categorise the ``.json`` file.

## Prerequistes
* Ensure you have a sample CV in ``.pdf`` format in ```/jobs/job-dir/data/raw_pdf/dt=yyyy-mm-dd``` (dt = current date).

## Run CV Analyser Spark Jobs
Create a Docker volume to mount on container 
1. Command to create a temporary container to create the docker volume named loadCV
CID=$(docker run -d -v loadCV:/loadCV:rw docker.io/jpacerqueira83/pyspark-k8s:2.4.5 true)

2. Navigate to job-dir
3. use below command to copy the contents of the CV-Analyzer/jobs/job-dir to the Docker volume loadCV
docker cp . $CID:/loadCV/
4. Delete the temporary container
docker rm $CID


Run the ``load-data-cv-to-delta`` job by executing ``` kubectl apply -f ./jobs/load-data-cv-to-delta.yaml ```. This will load the CV as described above. The output of this command will create a directory with curent ``` DATE ``` in ```/jobs/job-dir/data/raw_json/dt=yyyy-mm-dd/extract-yyyy-mm-dd.json```.

Upon a successful run of the above, proceed to executing ``` kubectl apply -f ./jobs/dataminer-categorized-delta-analytics.yaml ```. This commad will analyse and categorise the ``.json`` file and create a ``.parquet.crc`` file, which can be found in ``/jobs/job-dir/data/delta/json-cv-pdf `` and ``/jobs/job-dir/data/delta/cv-files-ngrams ``. 

