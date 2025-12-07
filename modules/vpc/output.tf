output "Main_vpc_id" {
  value = aws_vpc.Main.id
}

output "public_subnet_ids" {
  value = aws_subnet.public_subnet[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.private_subnet[*].id
}

output "availability_zones" {
  value = data.aws_availability_zones.Name.names
}

output "nat_gw_ids" {
  value = aws_nat_gateway.Nat_gw[*].id
}

output "igw_id" {
  value = aws_internet_gateway.Main_igw.id
}