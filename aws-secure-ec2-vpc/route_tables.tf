# Create Public Route Table
resource "aws_route_table" "ecc_public_rt" {
  vpc_id = aws_vpc.ecc_demo_vpc.id
  tags = {
    Name = "ecc-public-RT"
  }
}

# Create Route Table Association for Public Subnet
resource "aws_route_table_association" "public_subnet_association_a" {
  subnet_id      = aws_subnet.ecc_public_subnet_a.id
  route_table_id = aws_route_table.ecc_public_rt.id
}

# Create Route Table Association for Public Subnet
resource "aws_route_table_association" "public_subnet_association_b" {
  subnet_id      = aws_subnet.ecc_public_subnet_b.id
  route_table_id = aws_route_table.ecc_public_rt.id
}

# Create Route Table Association for Public Subnet
resource "aws_route_table_association" "public_subnet_association_c" {
  subnet_id      = aws_subnet.ecc_public_subnet_c.id
  route_table_id = aws_route_table.ecc_public_rt.id
}

# Add Route to Internet Gateway in Public Route Table
resource "aws_route" "internet_access" {
  route_table_id         = aws_route_table.ecc_public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.ecc_demo_igw.id
}