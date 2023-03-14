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

resource "aws_iam_role_policy_attachment" "ebay_scraper_tf_execution_policy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.ebay_scraper_tf.name
}

resource "aws_iam_role_policy_attachment" "ebay_scraper_tf_secrets_policy" {
  policy_arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
  role       = aws_iam_role.ebay_scraper_tf.name
}