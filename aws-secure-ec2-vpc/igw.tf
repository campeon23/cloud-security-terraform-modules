# Create Internet Gateway
resource "aws_internet_gateway" "ecc_demo_igw" {
  vpc_id = aws_vpc.ecc_demo_vpc.id
  tags = {
    Name = "ecc-demo-igw"
  }
}