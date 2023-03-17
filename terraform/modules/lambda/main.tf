# Defines IAM role for Lambda permissions
resource "aws_iam_role" "ebay_scraper_tf" {
  name = "ebay_scraper_tf_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Attaches lambda execution policy to role
# This is needed for the Lambda to run
resource "aws_iam_role_policy_attachment" "ebay_scraper_tf_execution_policy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.ebay_scraper_tf.name
}

# Attaches AWS Secrets Manager access policy to role
# This allows the lambda to access database credentials
resource "aws_iam_role_policy_attachment" "ebay_scraper_tf_secrets_policy" {
  policy_arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
  role       = aws_iam_role.ebay_scraper_tf.name
}

# Defines the lambda function itself
# Its function code is attached to an s3 bucket we define further down
resource "aws_lambda_function" "ebay_scraper_tf" {
  s3_bucket     = aws_s3_bucket.ebay_scraper_tf.bucket
  s3_key        = aws_s3_object.function_zip.key
  function_name = "ebay-scraper-tf"
  role          = aws_iam_role.ebay_scraper_tf.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.9"
  memory_size   = 128
  timeout       = 60
}

# S3 bucket that will hold function code for the lambda
resource "aws_s3_bucket" "ebay_scraper_tf" {
  bucket_prefix = "ebay-scraper-tf-"
}

# S3 object for the function code zip file that the lambda will execute
resource "aws_s3_object" "function_zip" {
  key    = "function.zip"
  bucket = aws_s3_bucket.ebay_scraper_tf.bucket
  source = "../ebay-scraper/function.zip"
}

# This will monitor the python code for ebay-scraper and automatically
# trigger the creation of a new zip file and upload to the S3 bucket whenever
# lambda_function.py changes.
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
}
