locals {
  cwd = "${path.module}"
}

resource "aws_s3_bucket" "ebay_scraper_tf_bucket" {
  bucket_prefix = "ebay-scraper-tf-"
}

resource "aws_s3_object" "function_zip" {
  key    = "function.zip"
  bucket = aws_s3_bucket.ebay_scraper_tf_bucket.bucket
  source = "${local.cwd}/ebay-scraper/function.zip"
}

# This will monitor the contents of the "lambda" directory and automatically
# trigger the creation of a new zip file and upload to the S3 bucket whenever
# lambda_function.py changes inside the directory.
resource "null_resource" "watch_lambda_function" {
  triggers = {
    lambda_func_checksum = "${filemd5("${local.cwd}/ebay-scraper/lambda/lambda_function.py")}"
  }

  provisioner "local-exec" {
    command = "cd ${local.cwd}/ebay-scraper && ./build.sh"
  }

  provisioner "local-exec" {
    command = "aws s3 cp ${local.cwd}/ebay-scraper/function.zip s3://${aws_s3_bucket.ebay_scraper_tf_bucket.bucket}/function.zip"
  }

  provisioner "local-exec" {
    command = "aws lambda update-function-code --function-name ${aws_lambda_function.ebay_scraper_tf_function.function_name} --s3-bucket ${aws_s3_bucket.ebay_scraper_tf_bucket.bucket} --s3-key function.zip"
  }
}
