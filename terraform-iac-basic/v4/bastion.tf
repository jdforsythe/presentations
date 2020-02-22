resource "aws_instance" "bastion" {
  ami = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name = "demo-app-key"
  subnet_id = module.vpc.public_subnets[0]
  vpc_security_group_ids = [aws_security_group.bastion.id]

  tags = {
    Name = "bastion"
    Environment = "test"
  }

  lifecycle {
    create_before_destroy = true
  }
}

output "bastion_ip_address" {
  value = aws_instance.bastion.public_ip
  description = "The public IP address of the bastion server"
}
