#!/bin/bash

SECRETS=$(aws secretsmanager get-secret-value --secret-id dev/ebay-scraper-tf/postgres \
  --query 'SecretString' --output text)

db_username=$(echo $SECRETS | sed -n 's/.*"username":"\([^"]*\)".*/\1/p')
db_password=$(echo $SECRETS | sed -n 's/.*"password":"\([^"]*\)".*/\1/p')
echo "db_username = \"$db_username\"" >> secrets.tfvars
echo "db_password = \"$db_password\"" >> secrets.tfvars

terraform plan -var-file="secrets.tfvars" --destroy
terraform apply -var-file="secrets.tfvars" --destroy --auto-approve

rm secrets.tfvars
