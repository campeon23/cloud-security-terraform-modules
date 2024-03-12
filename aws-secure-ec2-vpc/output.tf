# This file contains the output variables for the Terraform module.
output "ec2_instance_public_ip_address" {
  description = "The public IP address of the EC2 instance in the public subnet."
  value = aws_instance.ecc_public_ec2.public_ip
}

output "ec2_instance_private_ip_address" {
  description = "The private IP address of the EC2 instance in the private subnet."
  value = aws_instance.ecc_private_ec2.private_ip
}