locals {
  lambda_dir_path = "${path.module}/lambda"
}

data "archive_file" "lambda_zip" {
  type        = "zip"
  output_path = "${path.module}/lambda.zip"
  source_dir  = "${local.lambda_dir_path}"
}

resource "aws_s3_bucket" "ebay_scraper_tf_bucket" {
  bucket_prefix = "ebay-scraper-tf-bucket-"
}

resource "aws_s3_object" "lambda_zip" {
  key    = "function.zip"
  bucket = aws_s3_bucket.ebay_scraper_tf_bucket.bucket

  source = "${data.archive_file.lambda_zip.output_path}"
}

# This will monitor the contents of the "lambda" directory and automatically
# trigger the creation of a new zip file and upload to the S3 bucket whenever
# a file changes inside the directory.
resource "null_resource" "watch_lambda_dir" {
  triggers = {
    lambda_dir_checksum = "${filemd5("${local.lambda_dir_path}/lambda_function.py")}"
  }

  provisioner "local-exec" {
    command = "cd ${local.lambda_dir_path} && zip -r ../lambda.zip ."
  }

  provisioner "local-exec" {
    command = "aws s3 cp ${path.module}/lambda.zip s3://${aws_s3_bucket.ebay_scraper_tf_bucket.bucket}/function.zip"
  }
}

resource "null_resource" "function_deployment" {
  triggers = {
    function_sha256 = filesha256(data.archive_file.lambda_zip.output_path)
  }

  provisioner "local-exec" {
    command = "aws lambda update-function-code --function-name ${aws_lambda_function.ebay_scraper_tf_function.function_name} --s3-bucket ${aws_s3_bucket.ebay_scraper_tf_bucket.bucket} --s3-key function.zip"
  }
}