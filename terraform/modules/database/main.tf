# Only allows inbound access on Postgres port 5432
resource "aws_security_group" "db_security_group" {
  name_prefix = "ebay-scraper-tf-security-group"
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Defines the Postgres RDS instance
resource "aws_db_instance" "ebay_scraper_tf" {
  allocated_storage    = 20
  engine               = "postgres"
  engine_version       = "14.6"
  instance_class       = "db.t3.micro"
  identifier_prefix    = "ebay-scraper-tf-"
  db_name              = "ebay_listings"
  username             = var.db_username
  password             = var.db_password
  vpc_security_group_ids = [
    aws_security_group.db_security_group.id
  ]
  publicly_accessible = true
  skip_final_snapshot = true
}

# This automates the creation of the listings table that the lambda function will store data into
# Once the database is provisioned, it uses the CLI tool, psql, to execute the listingsTable.sql
# script on the ebay_listings database
resource "null_resource" "db_setup" {

  provisioner "local-exec" {

    command = "psql -h ${aws_db_instance.ebay_scraper_tf.address} -p 5432 -U ${var.db_username} -d ebay_listings -f ../listingsTable.sql"

    environment = {
      PGPASSWORD = var.db_password
    }
  }
}

# Defines the AWS Secrets Manager key to store database connection info
resource "aws_secretsmanager_secret" "db_connection" {
  name = "dev/ebay-scraper-tf/postgres"
}

# Adds username, password, and host address values to the secret key
# This allows the lambda to pull connection info from Secrets Manager and connect
resource "aws_secretsmanager_secret_version" "db_connection" {
  secret_id     = aws_secretsmanager_secret.db_connection.id
  secret_string = jsonencode({
    "username" = "${var.db_username}",
    "password" = "${var.db_password}",
    "host"     = "${aws_db_instance.ebay_scraper_tf.address}"
  })
}
