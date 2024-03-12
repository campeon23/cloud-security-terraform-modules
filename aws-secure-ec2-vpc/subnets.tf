# Create Public Subnet
resource "aws_subnet" "ecc_public_subnet_a" {
  vpc_id            = aws_vpc.ecc_demo_vpc.id
  cidr_block        = "10.0.2.0/24"
  map_public_ip_on_launch = "true"
  availability_zone = "us-east-1a"
  tags = {
    Name = "ecc-public-subnet"
  }
}

resource "aws_subnet" "ecc_public_subnet_b" {
  vpc_id            = aws_vpc.ecc_demo_vpc.id
  cidr_block        = "10.0.4.0/24"
  map_public_ip_on_launch = "true"
  availability_zone = "us-east-1b"
  tags = {
    Name = "ecc-public-subnet"
  }
}

resource "aws_subnet" "ecc_public_subnet_c" {
  vpc_id            = aws_vpc.ecc_demo_vpc.id
  cidr_block        = "10.0.6.0/24"
  map_public_ip_on_launch = "true"
  availability_zone = "us-east-1c"
  tags = {
    Name = "ecc-public-subnet"
  }
}


# Create Private Subnet
resource "aws_subnet" "ecc_private_subnet_a" {
  vpc_id            = aws_vpc.ecc_demo_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = false # Enable auto-assign public IP
  tags = {
    Name = "ecc-private-subnet"
  }
}

# Create Private Subnet
resource "aws_subnet" "ecc_private_subnet_b" {
  vpc_id            = aws_vpc.ecc_demo_vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = false # Enable auto-assign public IP
  tags = {
    Name = "ecc-private-subnet"
  }
}

# Create Private Subnet
resource "aws_subnet" "ecc_private_subnet_c" {
  vpc_id            = aws_vpc.ecc_demo_vpc.id
  cidr_block        = "10.0.5.0/24"
  availability_zone = "us-east-1c"
  map_public_ip_on_launch = false # Enable auto-assign public IP
  tags = {
    Name = "ecc-private-subnet"
  }
}