# asymmetric keypair
resource "aws_key_pair" "demo-app-key" {
  key_name = "demo-app-key"
  public_key = file("${path.root}/../.keys/terraform-demo-keys.pub")
}
