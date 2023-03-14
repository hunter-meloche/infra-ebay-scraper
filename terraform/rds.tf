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

resource "null_resource" "db_setup" {

  provisioner "local-exec" {

    command = "psql -h ${aws_db_instance.ebay_scraper_tf.address} -p 5432 -U ${var.db_username} -d ebay_listings -f ../listingsTable.sql"

    environment = {
      PGPASSWORD = var.db_password
    }
  }
}
