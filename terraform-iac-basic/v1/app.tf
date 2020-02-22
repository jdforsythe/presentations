# EC2 instance
resource "aws_instance" "app" {
  ami = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name = "demo-app-key"
  vpc_security_group_ids = [aws_security_group.app.id]

  tags = {
    Name = "app"
    Environment = "test"
  }

  user_data = <<EOF
#!/usr/bin/env bash
export DEBIAN_FRONTEND=noninteractive
apt-get update -qq
apt-get install ssl-cert nginx postgresql-10 -y

sed -i 's|# listen 443|listen 443|' /etc/nginx/sites-available/default
sed -i 's|# include snippets/snakeoil|include snippets/snakeoil|' /etc/nginx/sites-available/default

echo "Hello, I am $HOSTNAME and I connect to postgresql on localhost" > /var/www/html/index.html

service nginx enable
service nginx stop && service nginx start
service postgresql start
EOF
}

# module output and/or CLI output after `terraform apply`
output "app_ip_address" {
  value = aws_instance.app.public_ip
  description = "The public IP address of the app server"
}
