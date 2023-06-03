resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = {
    "Name" = "custom-VPC"
  }
}

resource "aws_subnet" "public_subnet" {
  count             = length(var.public_cidr)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_cidr[count.index]
  availability_zone = var.availability_zones
  tags = {
    "Name" = "public-1"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_cidr
  availability_zone = var.availability_zones
  tags = {
    "Name" = "private-1"
  }
}

resource "aws_internet_gateway" "ig_w" {
  vpc_id = aws_vpc.main.id
}

# Route  Table 

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ig_w.id
  }
  tags = {
    "Name" = "public-route-table"
  }
}

# Route Association 

resource "aws_route_table_association" "public_subnet" {
  count          = length(var.public_cidr)
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_eip" "nat" {
   count = length(var.public_cidr)
  domain = "vpc"
}

resource "aws_nat_gateway" "nat" {
  count = length(var.public_cidr)

  allocation_id = aws_eip.nat[count.index].id
  subnet_id      = aws_subnet.public_subnet[count.index].id
}

# Private Route table


resource "aws_route_table" "private_subnet" {
  count = length(var.public_cidr)
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat[count.index].id
  }
  tags = {
    "Name" = "private-route-table-1"
  }
}

# Route Association 

resource "aws_route_table_association" "private_subnet" {
  count = length(var.public_cidr)
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_subnet[count.index].id
}
