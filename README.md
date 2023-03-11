# infra-ebay-scraper
Terraform AWS IaC for [ebay-scraper](https://github.com/hunter-meloche/ebay-scraper). This tracks my current development infrastructure.

## Implemented
Provisions Lambda and an associated S3 bucket that hold the function code. A .zip of the Lambda function is automatically created and uploaded to the s3 bucket if it detects a code change based on the sha256 hash value of lambda_function.py.

Provisions a PostgreSQL RDS instance that is eligible for AWS' free tier. This will be where the ebay-scraper Lambda stores its findings.

## To-Do
Automate configuration of RDS instance

Automate storage of DB credentials to AWS Secrets Manager
