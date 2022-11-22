

 -  An setup to deploy Kubernetes in AWS EKS 
   - The Standard GKS spark was here adapted to EKS ( each terraform deploy / run costs less than $0.29 USD )
   -  Adopt multi-cloud strategies with this technologies and others compatible with Kubernetes and its auto-scaling capabilities.

          1. Step 0 : Setup your AWSCLI and account

           i.a.     $ brew install awscli
           i.b.     $ aws configure


   In AWS/EKS core - Execution  with Terraform deployment - analysis

         2. Setup implies the availability in an EC2 Gateway and setup of an EKS Kubernetes cluster

           i. Follow example in folder eks_deployment with script 
           i.a. [eks_deployment] $ bash -x step1-setup-terraform.sh  VAR1:_YOUR_LOCAL.pem   VAR2:_AWS_ACCESS_KEY_ID   VAR3:_AWS_SECRET_ACCESS_KEY   VAR4:_AWS_REGION  VAR5:_EKS_TF_CONFIG  


  ![EKS for spark- K8S - Teraform Hashicorp Default package](images/Deploy_Terraform_Fetch1.png)
  ![EKS for spark- K8S - Teraform Hashicorp Default package](images/Deploy_Terraform_plan_yes_2.png)
  ![EKS for spark- K8S - Teraform Hashicorp Default package](images/Deploy_Terraform_plan_EKS_3.png)
  ![EKS for spark- K8S - Teraform Hashicorp Default package](images/Deploy_Terraform_validate_output_4.png)

         3. Use Terraform destroy in folder eks_deployment/eks-cluster

           i.a.  [eks-cluster] $  terraform destroy

  ![EKS for spark- K8S - Teraform Hashicorp Default package](images/Terraform_destroy_5.png) 
   

         4. Deployment of Kubernetes infrastructure with AWS CLI
 
           i. confirm in ' aws eks '  the context when your cluster deployed
           i.a. [eks-cluster] $  aws eks --region eu-west-1 update-kubeconfig --name spark-eks-QiTsE99z 
             a.               $  Added new context arn:aws:eks:eu-west-1:512336214250:cluster/spark-eks-QiTsE99z to /Users/joci/.kube/config

  ![EKS for spark- K8S - Teraform Hashicorp Default package](images/AWS_CLI_add_EKS_context_6.png)


         5. AWS Console - EKS regional setup detials for Spark-EKS-Version.x.y.z

 
  ![AWS Console - Deployment of Kubernetes infrastructure with AWS CLI](images/AWS_Console_EKS_Cluster_7.png)


         6. using kubectl activate token and login to Kubernetes console

  ![Kubernetes - kubctl - proxy token - JOB1](images/Kubectl-Save-Token-Start-Proxy-v1.png)


 -  K8S workloads
    Where All operations executed in order :

   ./setup-k8s-spark-workload.sh

         1. spark/install-spark-kubernetes-operator
         2. spark/create-spark-service-account

  ![Kubernetes - proxy - JOB2](images/Setup-Proxy-Kubernetes-V2.png)

   ./execute-k8s-spark-workload.sh

         3. default spark-py-pi   OR  pyspark job under folder /jobs 

           i.   spark/run-spark-pi-2k8s-pods
           ii. e.g. ./execute-k8s-spark-workload.sh dataminer-categorized-pdf-to-csv-analytics


   In Kubernetes Proxy - Execution Analysis and logs
  
  ![Kubernetes - proxy - JOB3](images/Job-Execution-Spark-Kubernetes-V3.png)


   In Docker/Kubernetes core - Execution analysis


  ![DataMiner Notebook - package running in loal Kubernetes](images/JOB-Execution-v1.png)
  ![DataMiner Notebook - delta-lake package issue JOB1](images/K8S-PySpark-Dataminer-JOB1.png)
  ![DataMiner Notebook - delta-lake package issue JOB2](images/Dataminer-JOB2.png)
  ![DataMiner Notebook - delta-lake package issue JOB2](images/Dataminer-JOB3.png)
  ![DataMiner Notebook - delta-lake package issue JOB2](images/Dataminer-JOB4.png)
  ![DataMiner Notebook - delta-lake package issue JOB2](images/Dataminer-JOB5.png)


   Spark Running on Kubernetes

    i. Follow latest Spark.2.4.5 in : https://spark.apache.org/docs/latest/running-on-kubernetes.html 


   Spark Operator from GCP
    i.  https://github.com/GoogleCloudPlatform/spark-on-k8s-operator/blob/master/docs/api-docs.md 
    ii. sparkctl (dedicated kubectl) available from : https://github.com/GoogleCloudPlatform/spark-on-k8s-operator/tree/master/sparkctl


   EKS Operator for Terraform from Hashicorp HCL website
    i.  https://learn.hashicorp.com/terraform/kubernetes/provision-eks-cluster

 
   Next To\Do : adapted benchmark to EKS AKS with an dedicated sa3 S3 access layer for spark-executors/pods for filesystem. At the moment works in Spark with K8S filesystem
  
   Aditional Notes :  checkout branch execution_with_datapoints for data executions
  
   Aditional literature : Apache Spark in Kubernetes with Fast S3 access layer s3a : https://towardsdatascience.com/apache-spark-with-kubernetes-and-fast-s3-access-27e64eb14e0f


   -- test ---

