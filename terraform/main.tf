module "lambda" {
  source = "./modules/lambda"
}

module "database" {
  source = "./modules/database"

  # Pass in database credentials	
  db_username         = var.db_username
  db_password         = var.db_password
}
