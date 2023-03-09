# infra-ebay-scraper
Terraform AWS IaC for [ebay-scraper](https://github.com/hunter-meloche/ebay-scraper)

## Usage
This tracks my current infrastructure configuration for [ebay-scraper](https://github.com/hunter-meloche/ebay-scraper). So far, this automates turning the Python script and its dependencies into a zip and uploads it to an s3 bucket that the lambda function uses in AWS. The s3 bucket and lambda function will be created with this script. You just need to set up [AWS CLI](https://aws.amazon.com/cli/) and [Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli), and drop the Python script and its dependencies into the lambda folder.

## To-Do
Implement PostgreSQL RDS database in Terraform.

Automate storage of DB credentials to AWS Secrets Manager
