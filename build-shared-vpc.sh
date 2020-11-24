#!/bin/sh

cd ./terraform/01-infra
terraform init && terraform apply --auto-approve

