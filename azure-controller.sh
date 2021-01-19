#!/bin/sh
#############################################################################################################################
# Author - Travis Mitchell Jan16 2021
#
# Creates Azure SP and deploys Aviatrix Controller with az cli
#  
#
#############################################################################################################################
export DATE=`date '+%Y%m%d%hh%s'`
export LOG_DIR=$HOME/avx-azure-arm
mkdir -p ${LOG_DIR}

##################################
# Set up logfile
##################################
LOG_FILE=${LOG_DIR}/${DATE}_avx_az_arm.log

echo "###################################################################################"
echo "Aviatrix Azure Terraform SP started at `date`" 
echo "###################################################################################"
echo "Please Wait ..."

if ! [ -x "$(command -v az)" ]; then
  echo 'Error: Azure CLI is not installed.. Try brew install azure-cli' >&2 >> $LOG_FILE
  exit 1
fi

if ! [ -x "$(command -v jq)" ]; then
  echo 'Error: jq is not installed.. Try brew install jq' > $LOG_FILE >&2
  exit 1
fi

echo "Azure CLI and jq installed" 

echo "###################################################################################"
echo "Setting up Azure Aviatrix Service Princpal with Contributor role"
echo "###################################################################################"

read -p "Enter Azure Aviatrix Service Princpal Name (This is a user friendly name for you): "  appname
echo "Aviatrix Azure Terraform SP is $appname"
echo "This can be found in Azure Portal - Home > Your Subscription > Access control (IAM) > Check Access > $appname"

echo "###################################################################################"
echo "Setting up Azure Resource Group Enter a name for Azure Resource Group"
echo "###################################################################################"
read -p "Enter Azure Resource Group (This is a user friendly name for you): "  rgname
echo "Azure Resource Group is $rgname"

## Subscription id
SUB_ID=`az account show | jq -r '.id'`
echo "Subscription ID:         $SUB_ID" 

## Azure SP creation
az ad sp create-for-rbac -n $appname --role contributor --scopes /subscriptions/$SUB_ID >> avx_tf_sp_$DATE.json

## Set up TF ENV VARS 
ARM_CLIENT_ID=`cat avx_tf_sp_$DATE.json | jq -r '.appId'`
ARM_CLIENT_SECRET=`cat avx_tf_sp_$DATE.json | jq -r '.password'`
ARM_SUBSCRIPTION_ID=$SUB_ID
ARM_TENANT_ID=`cat avx_tf_sp_$DATE.json | jq -r '.tenant'`

echo "###################################################################################"
echo "Creating bootstrap avx_tf_sp.env file KEEP THIS FILE AND avx_tf_sp_$DATE.json SAFE!!!!"
echo ""
echo "Set up Terraform environment any time using this command - \$ source avx_tf_sp.env"
echo ""
echo "Check your environment       - \$ env | grep ARM"
echo ""
echo "This script sources your envionment on first run in this shell"
echo ""
echo "###################################################################################"

## Write to file
echo "# Aviatrix Bootstrap SP TF VARS created on $DATE" > avx_tf_sp.env 
echo "export ARM_CLIENT_ID=$ARM_CLIENT_ID" >> avx_tf_sp.env
echo "export ARM_CLIENT_SECRET=$ARM_CLIENT_SECRET" >> avx_tf_sp.env
echo "export ARM_SUBSCRIPTION_ID=$ARM_SUBSCRIPTION_ID" >> avx_tf_sp.env
echo "export ARM_TENANT_ID=$ARM_TENANT_ID" >> avx_tf_sp.env
echo "export TF_VAR_arm_application_id=$ARM_CLIENT_ID" >> avx_tf_sp.env
echo "export TF_VAR_arm_client_secret=$ARM_CLIENT_SECRET" >> avx_tf_sp.env
echo "export TF_VAR_arm_subscription_id=$ARM_SUBSCRIPTION_ID" >> avx_tf_sp.env
echo "export TF_VAR_arm_directory_id=$ARM_TENANT_ID" >> avx_tf_sp.env

## Source env variables
source avx_tf_sp.env

echo "###################################################################################"
echo "Launching the Aviatrix Controller"
echo ""
echo "aviatrix-systems:aviatrix-bundle-payg:aviatrix-enterprise-bundle-byol:6.2.1"
echo ""
echo "Accepting terms"
echo "###################################################################################"

###########################
STORAGE_ACCT=avxbootdiag-$DATE

az group create --name $rgname --location eastus --output table
az storage account create -n $STORAGE_ACCT -g RG-AVX-CONTROLLER -l eastus --sku Standard_LRS
az network vnet create --name VNET-AVX-CONTROLLER --resource-group $rgname --location eastus --address-prefix 10.0.0.0/24
az network vnet subnet create --vnet-name VNET-AVX-CONTROLLER --name SUB1 --resource-group $rgname --address-prefixes 10.0.0.0/24 --output table
az network public-ip create --name AVX-CONTROLLER --allocation-method Static --resource-group  $rgname --location eastus --sku Basic
az network nic create --resource-group $rgname --location eastus --name AVX-CONTROLLER-eth0 --vnet-name VNET-AVX-CONTROLLER --subnet SUB1 --public-ip-address  AVX-CONTROLLER --private-ip-address 10.0.0.4
az vm image terms accept --urn aviatrix-systems:aviatrix-bundle-payg:aviatrix-enterprise-bundle-byol:6.2.1
az vm create --resource-group $rgname --location eastus --name AVX-CONTROLLER --size Standard_D4S_v3 --nics AVX-CONTROLLER-eth0 --image aviatrix-systems:aviatrix-bundle-payg:aviatrix-enterprise-bundle-byol:6.2.1 --admin-username "devops" --admin-password "Aviatrix#123" --boot-diagnostics-storage $STORAGE_ACCT --no-wait