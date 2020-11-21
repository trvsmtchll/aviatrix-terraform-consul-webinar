# Aviatrix Vagrant Build

## Overview
This repo will deploy an ubuntu 18.04 machine using Vagrant with the latest AWS, Azure, and Google Cloud SDK. Terraform 12.29 will also be installed. The repo also will create a shared services VPC in AWS and launch a metered Aviatrix controller into it.<br>

## Pre-requisites

1. [Install Vagrant](https://www.vagrantup.com/downloads) on your workstation
2. [Install VirtualBox](https://www.virtualbox.org/wiki/Downloads) on your workstation
3. Set/export the following environment variables:
   1. AWS_SECRET_ACCESS_KEY
   2. AWS_ACCESS_KEY_ID

4. [Subscribe to the Aviatrix Controller in AWS Marketplace and Accept Terms](https://aws.amazon.com/marketplace/pp/B086T2RVTF/)


## Workflow

1. [Build VM](vagrant-box) 
   1. ```cd vagrant box```
   2. ```vagrant up``` 
   3. The ubuntu vm will take a few minutes, when its done ```vagrant ssh```
2. [Build Shared Services VPC](terraform/01-infra)
   1. ```cd 01-infra```
   2. ```terraform init```
   3. ```terraform plan```
   4. ```terraform apply --auto-approve```
3. [Launch Aviatrix Controller](terraform/02-aviatrix)
   1. ```cd 02-aviatrix```
   2. ```terraform init```
   3. ```terraform plan```
   4. ```terraform apply --auto-approve```


