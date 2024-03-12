# Create Security Group
resource "aws_security_group" "ecc_demo_sg" {
  name        = "ecc-demo-sg"
  description = "Allow all inbound traffic from my IP"
  vpc_id      = aws_vpc.ecc_demo_vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # All traffic
    cidr_blocks = ["83.171.251.17/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # All traffic
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ecc-demo-sg"
  }
}