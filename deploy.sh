#!/bin/bash

# Deletes local store of DB credentials if it exists
cd terraform
if [ -e secrets.tfvars ]; then
  rm secrets.tfvars
fi

# Checks if there is already an active deployment by attempting to retrieve database credentials
SECRETS=$(aws secretsmanager get-secret-value --secret-id dev/ebay-scraper-tf/postgres \
  --query 'SecretString' --output text >/dev/null 2>&1)

# Checks if DB credentials exist in AWS; if not, it prompts for new credentials
if [ $? -eq 0 ]; then
  db_username=$(echo $SECRETS | sed -n 's/.*"username":"\([^"]*\)".*/\1/p')
  db_password=$(echo $SECRETS | sed -n 's/.*"password":"\([^"]*\)".*/\1/p')
  echo "db_username = \"$db_username\"" >> secrets.tfvars
  echo "db_password = \"$db_password\"" >> secrets.tfvars
else
  echo "Desired database username: "
  read db_username
  echo "db_username = \"$db_username\"" >> secrets.tfvars
  echo "Desired database password: "
  read -s db_password
  echo "db_password = \"$db_password\"" >> secrets.tfvars
fi

# Clones or updates the app repo
cd ..
if [ -d ebay-scraper ]; then
  cd ebay-scraper
  git pull
else
  git clone https://github.com/hunter-meloche/ebay-scraper.git
  cd ebay-scraper
fi

# Ensures build script has permission to execute
chmod +x build.sh

# Provisions the infrastructure
cd ../terraform
terraform init
terraform plan -var-file="secrets.tfvars"
terraform apply -var-file="secrets.tfvars" --auto-approve

# Deletes local store of DB credentials
rm secrets.tfvars
