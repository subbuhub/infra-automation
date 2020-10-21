resource "aws_vpc" "new" {
  cidr_block           = var.vpc_cidr_block
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  tags = {
    Name = "${var.application}-${var.environment}"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.new.id
  cidr_block              = var.public_cidr_blocks[format("zone%d", count.index)]
  availability_zone       = var.zones[format("zone%d", count.index)]
  map_public_ip_on_launch = "true"
  count                   = length(var.public_cidr_blocks)

  tags = {
    "Name"                = "${var.application}-${var.environment}-pub-${var.zones[format("zone%d", count.index)]}"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id                  = aws_vpc.new.id
  cidr_block              = var.private_cidr_blocks[format("zone%d", count.index)]
  availability_zone       = var.zones[format("zone%d", count.index)]
  map_public_ip_on_launch = "false"
  count                   = length(var.private_cidr_blocks)
  tags = {
    "Name"                = "${var.application}-${var.environment}-pvt-${var.zones[format("zone%d", count.index)]}"
  }
}

resource "aws_eip" "nat" {
  vpc   = true
  count = length(var.public_cidr_blocks)
  tags = {
    Name = "${var.application}-${var.environment}-nat-${var.zones[format("zone%d", count.index)]}"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.new.id

  tags = {
    Name = "${var.application}-${var.environment}-igw"
  }
}

resource "aws_nat_gateway" "gw" {
  allocation_id = element(aws_eip.nat.*.id, count.index)
  subnet_id     = element(aws_subnet.public_subnet.*.id, count.index)
  count         = length(var.public_cidr_blocks)

  tags = {
    Name = "${var.application}-${var.environment}-nat"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.new.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name       = "${var.application}-${var.environment}-pub"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.new.id
  count  = length(var.private_cidr_blocks)

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = element(aws_nat_gateway.gw.*.id, count.index)
  }

  tags = {
    Name           = "${var.application}-${var.environment}-pvt-${var.zones[format("zone%d", count.index)]}"
  }
}

resource "aws_route_table_association" "private" {
  subnet_id      = element(aws_subnet.private_subnet.*.id, count.index)
  route_table_id = element(aws_route_table.private.*.id, count.index)
  count          = length(var.private_cidr_blocks)
}

resource "aws_route_table_association" "public" {
  subnet_id      = element(aws_subnet.public_subnet.*.id, count.index)
  route_table_id = aws_route_table.public.id
  count          = length(var.public_cidr_blocks)
}



