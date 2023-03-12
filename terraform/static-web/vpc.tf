resource "aws_vpc" "devopsrole_vpc" {
  cidr_block           = "10.10.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  instance_tenancy     = "default"

  tags = {
    Name = "devopsrole-vpc"
  }
}

resource "aws_subnet" "devopsrole_public_subnet" {
  vpc_id                                      = aws_vpc.devopsrole_vpc.id
  cidr_block                                  = "10.10.1.0/24"
  map_public_ip_on_launch                     = true
  availability_zone                           = "us-east-1a"
  enable_resource_name_dns_a_record_on_launch = true

  tags = {
    Name = "devopsrole_public_subnet"
  }
}

resource "aws_internet_gateway" "devopsrole_igw" {
  vpc_id = aws_vpc.devopsrole_vpc.id

  tags = {
    Name = "devopsrole_igw"
  }
}

resource "aws_route_table" "devopsrole_rt" {
  vpc_id = aws_vpc.devopsrole_vpc.id

  tags = {
    Name = "devopsrole_rt"
  }
}

resource "aws_route" "devopsrole_route" {
  route_table_id         = aws_route_table.devopsrole_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.devopsrole_igw.id
}

resource "aws_route_table_association" "devopsrole_rt_subnet_assoc" {
  subnet_id      = aws_subnet.devopsrole_public_subnet.id
  route_table_id = aws_route_table.devopsrole_rt.id
}

# resource "aws_route_table_association" "devopsrole_rt_igw_assoc" {
#   route_table_id = aws_route_table.devopsrole_rt.id
#   gateway_id     = aws_internet_gateway.devopsrole_igw.id
# }

resource "aws_security_group" "devopsrole_custom_tcp_sg" {
  name        = "allow_custom_tcp"
  description = "Allow custom tcp inbound traffic"
  vpc_id      = aws_vpc.devopsrole_vpc.id

  ingress {
    description = "Custom tcp from VPC"
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = [aws_route.devopsrole_route.destination_cidr_block]
  }

  egress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = [aws_route.devopsrole_route.destination_cidr_block]
  }

  tags = {
    Name = "devopsrole_custom_tcp_sg"
  }
}

resource "aws_security_group" "devopsrole_https_sg" {
  name        = "allow_https"
  description = "Allow https inbound traffic"
  vpc_id      = aws_vpc.devopsrole_vpc.id

  ingress {
    description = "https from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [aws_route.devopsrole_route.destination_cidr_block]
  }

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [aws_route.devopsrole_route.destination_cidr_block]
  }

  tags = {
    Name = "devopsrole_https_sg"
  }
}

resource "aws_security_group" "devopsrole_http_sg" {
  name        = "allow_http"
  description = "Allow http inbound traffic"
  vpc_id      = aws_vpc.devopsrole_vpc.id

  ingress {
    description = "http from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [aws_route.devopsrole_route.destination_cidr_block]
  }

  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [aws_route.devopsrole_route.destination_cidr_block]
  }

  tags = {
    Name = "devopsrole_http_sg"
  }
}

resource "aws_security_group" "devopsrole_ssh_sg" {
  name        = "allow_ssh"
  description = "Allow ssh inbound traffic"
  vpc_id      = aws_vpc.devopsrole_vpc.id

  ingress {
    description = "ssh from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [aws_route.devopsrole_route.destination_cidr_block]
  }

  egress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [aws_route.devopsrole_route.destination_cidr_block]
  }

  tags = {
    Name = "devopsrole_ssh_sg"
  }
}

/*
For all tcp allow / ssh connections use public ip for cid_block

resource "aws_security_group" "devopsrole_alltcp/ssh_sg" {
  name        = "allow_all_tcp/ssh"
  description = "Allow TCP inbound traffic"
  vpc_id      = aws_vpc.devopsrole_vpc.id

  ingress {
    description      = "TCP from VPC"
    from_port        = 0
    to_port          = 65535
    protocol         = "tcp"
    cidr_blocks      = ["public_ip"]
  }

  egress {
    from_port        = 0
    to_port          = 65535
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "devopsrole_alltcp_sg"
  }
}
*/