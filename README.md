# Aviatrix Vagrant Build

## Overview
This repo will deploy an ubuntu 18.04 machine using Vagrant with the latest AWS, Azure, Google Cloud SDK, and Terraform 12.29. The repo also will create a shared services VPC in AWS and launch a metered Aviatrix controller into it.<br>

## Pre-requisites

1. [Install Vagrant](https://www.vagrantup.com/downloads) on your workstation
2. [Install VirtualBox](https://www.virtualbox.org/wiki/Downloads) on your workstation
3. Set/export the following environment variables:
   1. AWS_SECRET_ACCESS_KEY
   2. AWS_ACCESS_KEY_ID

4. [Subscribe to the Aviatrix Controller in AWS Marketplace and Accept Terms](https://aws.amazon.com/marketplace/pp/B086T2RVTF/)


## Workflow

1. Clone this repository
2. ```vagrant up```
3. ```vagrant ssh```
4. ```cd /vagrant```
5. ```./build-shared-vpc.sh```
6. More to come - need to automate check for aviatrix-ec2-role with python


