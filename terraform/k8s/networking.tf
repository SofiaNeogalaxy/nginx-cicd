resource "aws_vpc" "prod-vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = "production"
  }
}

# Subnets have to be allowed to automatically map public IP addresses for worker nodes
resource "aws_subnet" "prod1-subnet" {
  vpc_id                  = aws_vpc.prod-vpc.id
  cidr_block              = var.prod1_subnet_cidr_block
  availability_zone       = var.prod1_subnet_az
  map_public_ip_on_launch = true

  tags = {
    Name                                        = "prod1-subnet"
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
    "kubernetes.io/role/elb"                    = "1"
  }
}

resource "aws_subnet" "prod2-subnet" {
  vpc_id                  = aws_vpc.prod-vpc.id
  cidr_block              = var.prod2_subnet_cidr_block
  availability_zone       = var.prod2_subnet_az
  map_public_ip_on_launch = true

  tags = {
    Name                                        = "prod2-subnet"
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
    "kubernetes.io/role/elb"                    = "1"
  }
}

resource "aws_internet_gateway" "prod-gw" {
  vpc_id = aws_vpc.prod-vpc.id

  tags = {
    Name = "prod-gw"
  }
}

resource "aws_route_table" "prod-route-table" {
  vpc_id = aws_vpc.prod-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.prod-gw.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.prod-gw.id
  }


  tags = {
    Name = "prod-rt"
  }
}

resource "aws_route_table_association" "prod1-sub-to-prod-rt" {
  subnet_id      = aws_subnet.prod1-subnet.id
  route_table_id = aws_route_table.prod-route-table.id
}

resource "aws_route_table_association" "prod2-sub-to-prod-rt" {
  subnet_id      = aws_subnet.prod2-subnet.id
  route_table_id = aws_route_table.prod-route-table.id
}

resource "aws_security_group" "allow-web-traffic" {
  name        = "allow_tls"
  description = "Allow web traffic"
  vpc_id      = aws_vpc.prod-vpc.id

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow-web"
  }
}
