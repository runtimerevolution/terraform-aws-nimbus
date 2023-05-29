# -----------------------------------------------------------------------------
# VPC
# -----------------------------------------------------------------------------
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr_block

  tags = {
    Name = "${var.solution_name}-vpc"
  }
}

# -----------------------------------------------------------------------------
# Public and private subnets
# -----------------------------------------------------------------------------
resource "aws_subnet" "public" {
  count                   = var.public_subnets_count
  cidr_block              = cidrsubnet(aws_vpc.vpc.cidr_block, 8, 2 + count.index)
  availability_zone       = data.aws_availability_zones.available_zones.names[count.index]
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = true
}

resource "aws_subnet" "private" {
  count             = var.private_subnets_count
  cidr_block        = cidrsubnet(aws_vpc.vpc.cidr_block, 8, count.index)
  availability_zone = data.aws_availability_zones.available_zones.names[count.index]
  vpc_id            = aws_vpc.vpc.id
}

# -----------------------------------------------------------------------------
# Internet gateway for communication between the VPC 
# and the rest of the internet
# -----------------------------------------------------------------------------
resource "aws_internet_gateway" "gateway" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_route" "internet_access" {
  route_table_id         = aws_vpc.vpc.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gateway.id
}

resource "aws_eip" "gateway" {
  count      = var.public_subnets_count
  vpc        = true
  depends_on = [aws_internet_gateway.gateway]
}

# -----------------------------------------------------------------------------
# NAT gateways allow communication from inside the VPC to outside 
# while preventing the other way around
# -----------------------------------------------------------------------------
resource "aws_nat_gateway" "gateway" {
  count         = var.public_subnets_count
  subnet_id     = element(aws_subnet.public.*.id, count.index)
  allocation_id = element(aws_eip.gateway.*.id, count.index)
}

resource "aws_route_table" "private" {
  count  = var.private_subnets_count
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = element(aws_nat_gateway.gateway.*.id, count.index)
  }
}

resource "aws_route_table_association" "private" {
  count          = var.private_subnets_count
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = element(aws_route_table.private.*.id, count.index)
}

# -----------------------------------------------------------------------------
# Security group
# -----------------------------------------------------------------------------
resource "aws_security_group" "security_group" {
  name   = "${var.solution_name}-security-group"
  vpc_id = aws_vpc.vpc.id

  ingress {
    protocol    = "tcp"
    from_port   = var.from_port
    to_port     = var.to_port
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
