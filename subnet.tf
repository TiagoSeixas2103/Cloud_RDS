# VPC
resource "aws_vpc" "vpc_database" {
    cidr_block = "10.0.0.0/16"
    enable_dns_hostnames = true
}

# Internet gateway
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc_database.id
}

# Tabela de Roteamento
resource "aws_route_table" "public_subnet_route_table" {
  vpc_id = aws_vpc.vpc_database.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }
}

# Sub-rede Pública Zona A
resource "aws_subnet" "public_subnet_us_east_1a" {
    vpc_id = aws_vpc.vpc_database.id
    cidr_block = "10.0.0.0/24"
    availability_zone = "us-east-1a"
    map_public_ip_on_launch = true
}

# Associação Sub-rede Pública com Tabela de Roteamento Zona A
resource "aws_route_table_association" "public_subnet_association_a" {
  subnet_id      = aws_subnet.public_subnet_us_east_1a.id
  route_table_id = aws_route_table.public_subnet_route_table.id
}

# Sub-rede Pública Zona B
resource "aws_subnet" "public_subnet_us_east_1b" {
    vpc_id = aws_vpc.vpc_database.id
    cidr_block = "10.0.3.0/24"
    availability_zone = "us-east-1b"
    map_public_ip_on_launch = true
}

# Associação Sub-rede Pública com Tabela de Roteamento Zona B
resource "aws_route_table_association" "public_subnet_association_b" {
  subnet_id      = aws_subnet.public_subnet_us_east_1b.id
  route_table_id = aws_route_table.public_subnet_route_table.id
}


# Sub-rede Privada Zona A
resource "aws_subnet" "private_subnet_us_east_1a" {
    vpc_id = aws_vpc.vpc_database.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "us-east-1a"
}

# Sub-rede Privada Zona B
resource "aws_subnet" "private_subnet_us_east_1b" {
    vpc_id = aws_vpc.vpc_database.id
    cidr_block = "10.0.2.0/24"
    availability_zone = "us-east-1b"
}

# Grupo de Sub-redes privadas
resource "aws_db_subnet_group" "subnet-database-group" {
  name       = "subnet-database-group-region1"
  subnet_ids = [aws_subnet.private_subnet_us_east_1a.id, aws_subnet.private_subnet_us_east_1b.id]

  tags = {
    Name = "DB-SubnetGroup-Region1"
  }
}


