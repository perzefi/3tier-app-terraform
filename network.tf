resource "aws_vpc" "demo-vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "3Tier-vpc"
  }
}

resource "aws_internet_gateway" "demo-igw" {
  vpc_id = aws_vpc.demo-vpc.id
  tags = {
    Name = "3Tier-vpc-IGW"
  }
}

resource "aws_eip" "nat" {
  count  = 2
  domain = "vpc"
}

resource "aws_nat_gateway" "nat" {
  count             = 2
  allocation_id     = aws_eip.nat[count.index].id
  subnet_id         = element(aws_subnet.public.*.id, count.index)
  connectivity_type = "public"
  depends_on        = [aws_internet_gateway.demo-igw]
  tags = {
    Name = "NAT-GW-${count.index + 1}"
  }
}

resource "aws_subnet" "public" {
  count             = 2
  vpc_id            = aws_vpc.demo-vpc.id
  cidr_block        = element(var.public_subnets, count.index)
  availability_zone = element(["us-east-1a", "us-east-1b"], count.index)

  map_public_ip_on_launch = true
  tags = {
    Name = "web-public-subnet-${count.index + 1}"
  }
}

resource "aws_subnet" "private" {
  count             = 4
  vpc_id            = aws_vpc.demo-vpc.id
  cidr_block        = element(var.private_subnets, count.index)
  availability_zone = element(["us-east-1a", "us-east-1b"], count.index % 2)
  tags = {
    Name = "${element(["app", "database"], floor(count.index / 2))}-private-subnet-${count.index % 2 + 1}"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.demo-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.demo-igw.id
  }
  tags = {
    Name = "Web-Public-Route"
  }
}

resource "aws_route_table_association" "public" {
  count          = 2
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  count  = 4
  vpc_id = aws_vpc.demo-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat[count.index % 2].id
  }
  tags = {
    Name = "${element(["App", "Database"], floor(count.index / 2))}-Private-Route-AZ${count.index % 2 + 1}"
  }
}

resource "aws_route_table_association" "private" {
  count          = 4
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}


resource "aws_db_subnet_group" "mysql" {
  name       = "dbmysql_subnet"
  subnet_ids = [aws_subnet.private[2].id, aws_subnet.private[3].id]
  tags = {
    Name = "dbwebmysql"
  }
}