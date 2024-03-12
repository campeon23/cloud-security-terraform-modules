# Create Network ACL
resource "aws_network_acl" "ecc_demo_acl" {
  vpc_id = aws_vpc.ecc_demo_vpc.id
  tags = {
    Name = "ecc-demo-ACL"
  }

  # Example rule - replace with your actual IP address
  ingress {
    action          = "allow"
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_block      = "83.171.251.17/32"
    rule_no         = 100
  }

  # Default egress rule: allow all out
  egress {
    action          = "allow"
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_block      = "0.0.0.0/0"
    rule_no         = 100
  }
}