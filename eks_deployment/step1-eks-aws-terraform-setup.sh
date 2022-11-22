#!/bin/bash
##
##################################################################
## Setup of Terraform Plan and dependencies in EKS or EC2 instance
##################################################################
set -e
#
LOCAL_PEM=$1  #Mandatory #example  ~/Documents/aws_keys/"gateway-aws-eks-eu1.pem"
#
###
export AWS_ACCESS_KEY_ID=$2
export AWS_SECRET_ACCESS_KEY=$3
### LIMIT REGIONS
REG_AWS=$4
#
if [ -z "$REG_AWS" ]; then
   REG_AWS=eu-west-1
fi   
export AWS_DEFAULT_REGION=$REG_AWS
###
EKS_SOURCE_TF=$5
if [ -z "$EKS_SOURCE_TF" ]; then
   EKS_SOURCE_TF=eks-cluster
fi
###
EC2_MACHINE=$6 # Optional TODO  # ubuntu@ec2-34-251-239-242.eu-west-1.compute.amazonaws.com
SETUP_SCRIPT=$7 # Optional TODO # ./setup-ec2-gateway-terraform.sh
HERE_TF=$(pwd)
EC2_HOME=/home/ubuntu
LOGIT=setup.log
###
if [ [ ! -z "$EC2_MACHINE+" ] && [ ! -z "$SETUP_SCRIPT+" ] ]; then
   #
   ssh -i $LOCAL_PEM -t $EC2_MACHINE "sudo rm -rf $EC2_HOME/*"
   scp -i $LOCAL_PEM  $SETUP_SCRIPT  $EC2_MACHINE:~
   #
   # Setup AWS EKS : Elastic Kubernetes Instance with default Hashicorp 3
   #
   ssh -i $LOCAL_PEM -t $EC2_MACHINE "sudo bash -x $SETUP_SCRIPT >> $LOGIT && mkdir -p $EC2_HOME/$EKS_SOURCE_TF >> $LOGIT"
   ################################################################################################# ERRORS rsync key isssue  ## rsync -aPv — progress -e "ssh -i $LOCAL_PEM $EC2_MACHINE " $HERE_TF/$EKS_SOURCE_TF  $EC2_MACHINE:$EC2_HOME/$EKS_SOURCE_TF
   scp -i $LOCAL_PEM $HERE_TF/$EKS_SOURCE_TF/*.* $EC2_MACHINE:$EC2_HOME/$EKS_SOURCE_TF 
   #
   ################################################################################################# ERRORS AWS_CLI blocked #ssh -i $LOCAL_PEM -t ${EC2_MACHINE} "source ${EC2_HOME}/.bashrc && cd $EC2_HOME/$EKS_SOURCE_TF && terraform init >> $LOGIT  && terraform apply  >> $LOGIT "
else 
   #
   # Setup AWS EKS : Elastic Kubernetes Instance with default Hashicorp 3
   #
   cd $HERE_TF/$EKS_SOURCE_TF && terraform init && terraform plan && terraform apply && aws eks --region $REG_AWS update-kubeconfig --name ${EKS_NAME} 
   #
   # BUG FIX : https://github.com/terraform-aws-modules/terraform-aws-eks/issues/757 
   # Workaround is to override the wait_for_cluster_cmd and use the default value prior to 750 e.g.
   export wait_for_cluster_cmd = "until curl -k -s $ENDPOINT/healthz >/dev/null; do sleep 4; done"
   #
fi
#
# Setup Spark Kubernetes Baremetal instances
echo "D_4_ it! "
#
