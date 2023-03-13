# Define the new secret
resource "aws_secretsmanager_secret" "db_connection" {
  name = "dev/ebay-scraper-tf/postgres"
}

# Add a value to the secret
resource "aws_secretsmanager_secret_version" "db_connection" {
  secret_id     = aws_secretsmanager_secret.db_connection.id
  secret_string = jsonencode({
    "username" = "${var.db_username}",
    "password" = "${var.db_password}",
    "host"     = "${aws_db_instance.db_instance.address}"
  })
}
