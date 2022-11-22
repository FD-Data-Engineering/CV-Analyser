#!/bin/bash
##
set -e
##
HEREIS=$(pwd)
sudo -u root apt-get install zip
wget https://releases.hashicorp.com/terraform/0.12.26/terraform_0.12.26_linux_amd64.zip  
# wget  https://releases.hashicorp.com/terraform/0.12.26/terraform_0.12.26_darwin_amd64.zip

HEREIS=$(pwd)
mkdir -p ${HEREIS}/opt/terraform
sudo unzip terraform_0.12.26_linux_amd64.zip  -d ${HEREIS}/opt/terraform
# sudo unzip terraform_0.12.26_darwin_amd64.zip  -d ${HEREIS}/opt/terraform
sudo chown -Rv ubuntu:ubuntu ${HEREIS}/opt/
#
echo "PATH='${HEREIS}/opt/terraform:$PATH'#" >> ~/.bashrc
export PATH="${HEREIS}/opt/terraform:$PATH"
source ~/.bashrc
terraform --version
#
