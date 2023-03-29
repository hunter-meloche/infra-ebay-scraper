# infra-ebay-scraper
Terraform AWS IaC for [ebay-scraper](https://github.com/hunter-meloche/ebay-scraper). This tracks my current development infrastructure.

Just run deploy.sh, answer a few prompts and you'll have a working cloud deployment of ebay-scraper that analyzes whatever items you want. I would recommend creating an EventBridge Schedule for each item.

## Disclaimer
This is not to be used for commercial purposes or harm eBay. This project is for educational purposes only and not intended to be used in any way to break eBay or Cloudflare's Terms of Service agreements. Web scraping publicly available information is legal where I live, but check your own local laws.

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
