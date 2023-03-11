#!/bin/bash

# Check if DB credentials already exist in secrets.tfvars; if they're not found, prompt for input
if [[ ! $(sed -n '1p' secrets.tfvars) ]] || [[ ! $(sed -n '2p' secrets.tfvars) ]]; then
  echo "Desired database username: "
  read db_username
  echo "db_username = \"$db_username\"" >> secrets.tfvars
  echo "Desired database password: "
  read -s db_password
  echo "db_password = \"$db_password\"" >> secrets.tfvars
fi

# Clones or pulls the app repo
if cd ebay-scraper; then
  git pull
else
  git clone https://github.com/hunter-meloche/ebay-scraper.git
  cd ebay-scraper
fi

# Places the function in the infra lambda directory
chmod +x build.sh
./build.sh

cd ..
terraform init
terraform plan -var-file="secrets.tfvars"
terraform apply -var-file="secrets.tfvars" --auto-approve
