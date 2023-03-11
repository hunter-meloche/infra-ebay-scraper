resource "aws_security_group" "db_security_group" {
  name_prefix = "ebay-scraper-tf-security-group"
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
