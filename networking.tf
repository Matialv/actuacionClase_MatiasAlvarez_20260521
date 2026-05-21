resource "aws_vpc" "AC2-vpc" {
  cidr_block           = "10.10.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "AC2-vpc"
  }
}

resource "aws_internet_gateway" "AC2-igw" {
  vpc_id = aws_vpc.AC2-vpc.id

  tags = {
    Name = "AC2-igw"
  }
}

resource "aws_subnet" "AC2-subnet-public-a" {
  vpc_id                  = aws_vpc.AC2-vpc.id
  cidr_block              = "10.10.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "AC2-subnet-public-a"
  }
}

resource "aws_subnet" "AC2-subnet-public-b" {
  vpc_id                  = aws_vpc.AC2-vpc.id
  cidr_block              = "10.10.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "AC2-subnet-public-b"
  }
}

resource "aws_subnet" "AC2-subnet-private-a" {
  vpc_id            = aws_vpc.AC2-vpc.id
  cidr_block        = "10.10.3.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "AC2-subnet-private-a"
  }
}

resource "aws_subnet" "AC2-subnet-private-b" {
  vpc_id            = aws_vpc.AC2-vpc.id
  cidr_block        = "10.10.4.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "AC2-subnet-private-b"
  }
}

resource "aws_eip" "AC2-eip-ngw" {
  domain = "vpc"

  tags = {
    Name = "AC2-eip-ngw"
  }
}

resource "aws_nat_gateway" "AC2-ngw" {
  allocation_id = aws_eip.AC2-eip-ngw.id
  subnet_id     = aws_subnet.AC2-subnet-public-b.id

  tags = {
    Name = "AC2-ngw"
  }

  depends_on = [aws_internet_gateway.AC2-igw]
}

resource "aws_route_table" "AC2-rt-public" {
  vpc_id = aws_vpc.AC2-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.AC2-igw.id
  }

  tags = {
    Name = "AC2-rt-public"
  }
}

resource "aws_route_table_association" "AC2-rta-public-a" {
  subnet_id      = aws_subnet.AC2-subnet-public-a.id
  route_table_id = aws_route_table.AC2-rt-public.id
}

resource "aws_route_table_association" "AC2-rta-public-b" {
  subnet_id      = aws_subnet.AC2-subnet-public-b.id
  route_table_id = aws_route_table.AC2-rt-public.id
}

resource "aws_route_table" "AC2-rt-private" {
  vpc_id = aws_vpc.AC2-vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.AC2-ngw.id
  }

  tags = {
    Name = "AC2-rt-private"
  }
}

resource "aws_route_table_association" "AC2-rta-private-a" {
  subnet_id      = aws_subnet.AC2-subnet-private-a.id
  route_table_id = aws_route_table.AC2-rt-private.id
}

resource "aws_route_table_association" "AC2-rta-private-b" {
  subnet_id      = aws_subnet.AC2-subnet-private-b.id
  route_table_id = aws_route_table.AC2-rt-private.id
}