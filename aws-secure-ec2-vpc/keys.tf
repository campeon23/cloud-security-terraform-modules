resource "tls_private_key" "ecc_demo" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "ecc_demo_key" {
  key_name   = "ecc-demo-key"
  public_key = tls_private_key.ecc_demo.public_key_openssh
}

resource "local_file" "private_key" {
  content  = tls_private_key.ecc_demo.private_key_pem
  filename = "${path.module}/ecc-demo-key.pem"
}