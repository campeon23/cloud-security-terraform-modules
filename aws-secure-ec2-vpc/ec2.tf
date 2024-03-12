# Launch EC2 Instance in Public Subnet
resource "aws_instance" "ecc_public_ec2" {
  ami                       = "ami-0a3c14e1ddbe7f23c" # Replace with the actual AMI ID for Amazon Linux 2
  instance_type             = "t3.micro"
  key_name                  = aws_key_pair.ecc_demo_key.key_name # Replace with your key name
  subnet_id                 = random_shuffle.public_subnet_ids.result[0]
  vpc_security_group_ids    = [aws_security_group.ecc_demo_sg.id]
  monitoring                = true  # Enable detailed monitoring
  ebs_optimized             = true  # This line should be either changed to a supported instance type or removed if using t2.micro
  associate_public_ip_address = true # Ensure a public IP is assigned

  tags = {
    Name = "ecc-public-ec2"
    Department = "Engineering"
  }
}

# Launch EC2 Instance in Private Subnet
resource "aws_instance" "ecc_private_ec2" {
  ami                       = "ami-0e1c5d8c23330dee3" # Replace with the actual AMI ID for Amazon Linux 2
  instance_type             = "t3.micro"
  key_name                  = aws_key_pair.ecc_demo_key.key_name # Replace with your key name
  subnet_id                 = random_shuffle.private_subnet_ids.result[0]
  vpc_security_group_ids    = [aws_security_group.ecc_demo_sg.id]
  monitoring                = true  # Enable detailed monitoring
  ebs_optimized             = true  # Enable EBS optimization
  associate_public_ip_address = false # Ensure no public IP is assigned

  tags = {
    Name = "ecc-private-ec2"
    Department = "Engineering"
  }
}

resource "random_shuffle" "public_subnet_ids" {
  input        = [aws_subnet.ecc_public_subnet_a.id, aws_subnet.ecc_public_subnet_b.id, aws_subnet.ecc_public_subnet_c.id]
  result_count = 1
}

resource "random_shuffle" "private_subnet_ids" {
  input        = [aws_subnet.ecc_private_subnet_a.id, aws_subnet.ecc_private_subnet_b.id, aws_subnet.ecc_private_subnet_c.id]
  result_count = 1
}
