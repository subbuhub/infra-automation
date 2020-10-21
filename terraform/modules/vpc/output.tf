output "id" {
  value = aws_vpc.new.id
}

output "cidr" {
  value = aws_vpc.new.cidr_block
}

output "private_subnet_ids" {
  value = aws_subnet.private_subnet.*.id
}

output "public_subnet_ids" {
  value = aws_subnet.public_subnet.*.id
}

output "eip" {
  value = aws_eip.nat.*.public_ip
}

output "gateway_id" {
  value = aws_internet_gateway.gw.id
}

output "nat_id" {
  value = aws_nat_gateway.gw.*.id
}

output "nat_public_ips" {
  value = aws_nat_gateway.gw.*.public_ip
}

output "route_table_public_ID" {
  value = aws_route_table.public.id
}

output "route_table_private_ID" {
  value = aws_route_table.private[*].id
}

output "aws_route_table_association_private" {
  value = aws_route_table_association.private.*.id
}

output "aws_route_table_association_public" {
  value = aws_route_table_association.public.*.id
}