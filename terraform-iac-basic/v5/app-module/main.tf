resource "aws_instance" "app" {
  count = 3
  ami = var.ami
  instance_type = "t2.micro"
  key_name = "demo-app-key"
  subnet_id = element(var.private_subnets, count.index)
  vpc_security_group_ids = [var.app_security_group, var.db_security_group]

  tags = {
    # app01, app02, ... appNN
    Name = format("app%02d", count.index + 1)
    Environment = "test"
  }

  lifecycle {
    create_before_destroy = true
  }

  user_data = <<EOF
#!/usr/bin/env bash
export DEBIAN_FRONTEND=noninteractive
apt-get update -qq
apt-get install ssl-cert nginx -y

sed -i 's|# listen 443|listen 443|' /etc/nginx/sites-available/default
sed -i 's|# include snippets/snakeoil|include snippets/snakeoil|' /etc/nginx/sites-available/default

echo "Hello, I am $HOSTNAME and I connect to postgresql on ${aws_db_instance.app_db.endpoint}" > /var/www/html/index.html

service nginx enable
service nginx stop && service nginx start
service postgresql start
EOF
}
