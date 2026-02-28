data "aws_availability_zones" "available" {}

resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr
  tags       = merge({ Name = var.name }, var.tags)
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.this.id
  tags   = merge({ Name = "${var.name}-igw" }, var.tags)
}

resource "aws_subnet" "public" {
  for_each              = toset(data.aws_availability_zones.available.names)
  vpc_id                = aws_vpc.this.id
  cidr_block            = cidrsubnet(var.vpc_cidr, 8, index(data.aws_availability_zones.available.names, each.key))
  availability_zone     = each.key
  map_public_ip_on_launch = true
  tags                  = merge({ Name = "${var.name}-public-${each.key}" }, var.tags)
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = merge({ Name = "${var.name}-public-rt" }, var.tags)
}

resource "aws_route_table_association" "public_assoc" {
  for_each      = aws_subnet.public
  subnet_id     = each.value.id
  route_table_id = aws_route_table.public.id
}
