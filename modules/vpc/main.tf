# modules/vpc/main.tf
#
# Creates a standard VPC with public and private subnets across multiple
# Availability Zones, an Internet Gateway, and route tables.

# ---
# Data sources: discover what AZs are available in the current region.
# ---
data "aws_availability_zones" "available" {
  state = "available"
}

# ---
# The VPC itself.
# ---
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(var.tags, {
    Name  = "${var.name_prefix}-vpc"
    Owner = var.trainee_name
  })
}

# ---
# Internet Gateway - the door between the VPC and the public internet.
# ---
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = merge(var.tags, {
    Name  = "${var.name_prefix}-igw"
    Owner = var.trainee_name
  })
}

# ---
# Public subnets - one per AZ, with auto-assigned public IPs.
# ---
resource "aws_subnet" "public" {
  count = var.az_count

  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, count.index + 1)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = merge(var.tags, {
    Name  = "${var.name_prefix}-public-${count.index + 1}"
    Type  = "public"
    Owner = var.trainee_name
  })
}

# ---
# Private subnets - one per AZ, no public IPs.
# ---
resource "aws_subnet" "private" {
  count = var.az_count

  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, count.index + 11)
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = merge(var.tags, {
    Name  = "${var.name_prefix}-private-${count.index + 1}"
    Type  = "private"
    Owner = var.trainee_name
  })
}

# ---
# Public route table - routes 0.0.0.0/0 to the Internet Gateway.
# ---
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = merge(var.tags, {
    Name  = "${var.name_prefix}-public-rt"
    Owner = var.trainee_name
  })
}

# ---
# Private route table - no internet route (stays private).
# ---
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = merge(var.tags, {
    Name  = "${var.name_prefix}-private-rt"
    Owner = var.trainee_name
  })
}

# ---
# Associate public subnets with the public route table.
# ---
resource "aws_route_table_association" "public" {
  count = var.az_count

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# ---
# Associate private subnets with the private route table.
# ---
resource "aws_route_table_association" "private" {
  count = var.az_count

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}