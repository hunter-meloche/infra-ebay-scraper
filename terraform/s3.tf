# S3 bucket that will hold function code for lambda
resource "aws_s3_bucket" "ebay_scraper_tf" {
  bucket_prefix = "ebay-scraper-tf-"
}

# S3 objecto for the function code zip file
resource "aws_s3_object" "function_zip" {
  key    = "function.zip"
  bucket = aws_s3_bucket.ebay_scraper_tf.bucket
  source = "../ebay-scraper/function.zip"
}

# This will monitor the contents of the "lambda" directory and automatically
# trigger the creation of a new zip file and upload to the S3 bucket whenever
# lambda_function.py changes inside the directory.
resource "null_resource" "watch_lambda_function" {
  triggers = {
    lambda_func_checksum = "${filemd5("../ebay-scraper/lambda/lambda_function.py")}"
  }

  provisioner "local-exec" {
    command = "cd ../ebay-scraper/ && ./build.sh"
  }

  provisioner "local-exec" {
    command = "aws s3 cp ../ebay-scraper/function.zip s3://${aws_s3_bucket.ebay_scraper_tf.bucket}/function.zip"
  }

  provisioner "local-exec" {
    command = "aws lambda update-function-code --function-name ${aws_lambda_function.ebay_scraper_tf.function_name} --s3-bucket ${aws_s3_bucket.ebay_scraper_tf.bucket} --s3-key ${aws_s3_object.function_zip.key}"
  }
}
