#!/usr/bin/env bash

echo 'Installing project dependencies'

for i in 
    sudo apt-get update -y
    sudo apt-get install dos2unix
    sudo apt install -y default-jre
    sudo pip3 install pyOpenSSL --upgrade
    sudo pip3 install pandas
    sudo pip3 install numpy
    sudo pip3 install pdfminer.six
    sudo pip3 install pyspark
    sudo pip3 install scipy
    apt -y install unzip; do
  sudo apt-get install $i

echo 'All dependencies have been successfully installed'
