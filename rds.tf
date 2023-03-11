resource "aws_db_instance" "db_instance" {
  allocated_storage    = 20
  engine               = "postgres"
  engine_version       = "14.6"
  instance_class       = "db.t3.micro"
  db_name              = "ebayScraperTf"
  username             = var.db_username
  password             = var.db_password
  vpc_security_group_ids = [
    aws_security_group.db_security_group.id
  ]
  publicly_accessible = true
  skip_final_snapshot = true
}
