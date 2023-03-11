#!/bin/bash

terraform plan -var-file="secrets.tfvars" --destroy
terraform apply -var-file="secrets.tfvars" --destroy --auto-approve
