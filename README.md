# infra-ebay-scraper
Terraform AWS IaC for [ebay-scraper](https://github.com/hunter-meloche/ebay-scraper). This tracks my current development infrastructure.

The idea is you just run deploy.sh, answer a few prompts and then having a working cloud deployment of ebay-scraper that feed whatever events you want into.

## Dependencies
```
AWS CLI
Terraform
UNIX Shell
psql
```
[Guide for psql](https://www.compose.com/articles/postgresql-tips-installing-the-postgresql-client/)

## How to use
Run deploy.sh and it will prompt you to set a database username and password the first time it runs. Database credentials are saved in AWS Secrets Manager.

To tear down everything it's provisioned, run destroy.sh.

## Implemented
Provisions Lambda and an associated S3 bucket that holds the function code. A .zip of the Lambda function is automatically created and uploaded to the s3 bucket if it detects a code change based on the md5 value of lambda_function.py. In other words, you can run the deploy script again to update the code that's actively scanning your ebay items without any headache.

Provisions a PostgreSQL RDS instance that is eligible for AWS' free tier. This will be where the ebay-scraper Lambda stores its findings. The table to store scraped eBay listings is automatically created. What you do with that data is up to you. I'll be making analysis tools further down the line. Right I'm just tracking the price action of items with graphs.

![3080 price chart](https://user-images.githubusercontent.com/123516285/225489039-cd0d8d7e-e8b5-4a7b-ae61-9e4e4494e9fc.PNG)
