# infra-ebay-scraper
Terraform AWS IaC for [ebay-scraper](https://github.com/hunter-meloche/ebay-scraper). This tracks my current development infrastructure.

## Dependencies
```
AWS CLI
Terraform
UNIX Shell
psql
```

## How to use
Run deploy.sh and it will prompt you to set a database username and password the first time it runs. Database credentials are saved in AWS Secrets Manager.

To tear down everything it's provisioned, run terminate.sh.

## Implemented
Provisions Lambda and an associated S3 bucket that holds the function code. A .zip of the Lambda function is automatically created and uploaded to the s3 bucket if it detects a code change based on the sha256 hash value of lambda_function.py.

Provisions a PostgreSQL RDS instance that is eligible for AWS' free tier. This will be where the ebay-scraper Lambda stores its findings. The table to store scraped eBay listings is automatically created.
