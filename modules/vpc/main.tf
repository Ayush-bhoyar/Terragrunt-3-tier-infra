resource "aws_vpc" "Main" {
  cidr_block           = var.main_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name    = "3-tier-app-${var.environment}"
    Project = "3-tier-Infra"

  }
}

locals {
  total_subnet_count = var.public_subnet_count + var.private_subnet_count
  total_bits         = ceil(log(local.total_subnet_count, 2))
}

data "aws_availability_zones" "Name" {

}

resource "aws_subnet" "public_subnet" {
  count                   = var.public_subnet_count
  cidr_block              = cidrsubnet(aws_vpc.Main.cidr_block, local.total_bits, count.index)
  availability_zone       = data.aws_availability_zones.Name.names[count.index % length(data.aws_availability_zones.Name.names)]
  vpc_id                  = aws_vpc.Main.id
  map_public_ip_on_launch = true

  tags = {
    Name    = "Public-subnet-${count.index}-${var.environment}"
    Project = "3-tier-Infra"
  }
}

resource "aws_subnet" "private_subnet" {
  count                   = var.private_subnet_count
  cidr_block              = cidrsubnet(aws_vpc.Main.cidr_block, local.total_bits, var.public_subnet_count + count.index)
  availability_zone       = data.aws_availability_zones.Name.names[count.index % length(data.aws_availability_zones.Name.names)]
  vpc_id                  = aws_vpc.Main.id
  map_public_ip_on_launch = false

  tags = {
    Name    = "Private-subnet-${count.index}-${var.environment}"
    Project = "3-tier-Infra"
  }
}

resource "aws_internet_gateway" "Main_igw" {
  vpc_id = aws_vpc.Main.id

  tags = {
    Name    = "3-tier-app-${var.environment}"
    Project = "3-tier-Infra"

  }
}

resource "aws_eip" "Nat_eip" {
  count  = var.public_subnet_count
  domain = "vpc"
  
  tags = {
    Name    = "3-tier-app-${var.environment}"
    Project = "3-tier-Infra"

  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_nat_gateway" "Nat_gw" {
  count         = var.public_subnet_count
  allocation_id = aws_eip.Nat_eip[count.index].id
  subnet_id     = aws_subnet.public_subnet[count.index].id

  tags = {
    Name    = "Nat_gateway-${count.index}-${var.environment}"
    Project = "3-tier-Infra"

  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.Main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Main_igw.id
  }

  tags = {
    Name    = "3-tier-app-public-rt-${var.environment}"
    Project = "3-tier-Infra"

  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route_table_association" "public-rta" {
  count          = var.public_subnet_count
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_rt.id

}

resource "aws_route_table" "private_rt" {
  count  = var.private_subnet_count
  vpc_id = aws_vpc.Main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.Nat_gw[count.index].id
  }

  tags = {
    Name    = "3-tier-app-private-rt-${var.environment}"
    Project = "3-tier-Infra"

  }
}

resource "aws_route_table_association" "private_rta" {
  count          = var.private_subnet_count
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_rt[count.index].id
}




