# generate a random initial password for the RDS admin account
resource "random_uuid" "db_password" {}

resource "aws_db_instance" "app_db" {
  name = "app"
  identifier = "app-test"
  allocated_storage = 80
  storage_type = "gp2"
  engine = "postgres"
  engine_version = "10.6"
  instance_class = "db.t2.micro"
  username = "dbadmin"
  password = random_uuid.db_password.result
  vpc_security_group_ids = [var.db_security_group]
  db_subnet_group_name = var.db_subnet_group
  skip_final_snapshot = true

  tags = {
    Environment = "test"
  }
}
