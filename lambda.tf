resource "aws_lambda_function" "ebay_scraper_tf_function" {
  s3_bucket     = aws_s3_bucket.ebay_scraper_tf_bucket.bucket
  s3_key        = aws_s3_object.function_zip.key
  function_name = "ebay-scraper-tf"
  role          = aws_iam_role.ebay_scraper_tf.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.9"
  memory_size   = 128
  timeout       = 60
}
