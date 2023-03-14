#!/bin/bash

cd terraform
echo "db_username = \"null\"" >> secrets.tfvars
echo "db_password = \"null\"" >> secrets.tfvars

terraform plan -var-file="secrets.tfvars" --destroy
terraform apply -var-file="secrets.tfvars" --destroy --auto-approve

rm secrets.tfvars

aws secretsmanager delete-secret --secret-id dev/ebay-scraper-tf/postgres --force-delete-without-recovery
