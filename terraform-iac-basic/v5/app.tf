module "app_module" {
  source = "./app-module"

  ami = data.aws_ami.ubuntu.id

  app_security_group = aws_security_group.app.id
  private_subnets = module.vpc.private_subnets

  db_security_group = aws_security_group.app_db.id
  db_subnet_group = module.vpc.database_subnet_group
}
