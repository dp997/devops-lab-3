#`````````````
#VPC config
#`````````````
resource "aws_vpc" "VPC" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = "${var.project_name}-VPC"
  }
  enable_dns_hostnames = true
  enable_dns_support = true
}

#````````````
#Internet Gateway config
#````````````
resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.VPC.id
  tags = {
    Name = "${var.project_name}-IGW"
  }
}

#````````````
#Public subnets
#````````````
resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = aws_vpc.VPC.id
  cidr_block              = var.public_subnet_1_cidr_block
  map_public_ip_on_launch = true
  availability_zone       = "${var.aws_region}a"
  tags = {
    Name = "public-subnet-1"
  }
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id                  = aws_vpc.VPC.id
  cidr_block              = var.public_subnet_2_cidr_block
  map_public_ip_on_launch = true
  availability_zone       = "${var.aws_region}b"
  tags = {
    Name = "public-subnet-2"
  }
}

#```````````
#Private subnets
#```````````
resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.VPC.id
  cidr_block        = var.private_subnet_1_cidr_block
  availability_zone = "${var.aws_region}a"
  tags = {
    Name = "private-subnet-1"
  }
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.VPC.id
  cidr_block        = var.private_subnet_2_cidr_block
  availability_zone = "${var.aws_region}b"
  tags = {
    Name = "private-subnet-2"
  }
}

#``````````
#Route tables
#``````````
#Public route tables
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.VPC.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IGW.id
  }

  tags = {
    Name = "public-rt"
  }
}

resource "aws_route_table_association" "public_rt_association_1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_rt_association_2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_rt.id
}

#Private route tables
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.VPC.id

  route {
    cidr_block     = "0.0.0.0/0"
    network_interface_id = aws_network_interface.nat_interface.id
  }

  tags = {
    Name = "private-rt"
  }
}

resource "aws_route_table_association" "private_rt_association_1" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_rt_association_2" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.private_rt.id
}

#```````````
#Elastic IP
#```````````
resource "aws_eip" "eip1" {
  domain     = "vpc"
  depends_on = [aws_internet_gateway.IGW]
}

#```````````
#NAT gateway
#```````````
# resource "aws_nat_gateway" "NAT" {
#   connectivity_type = "public"
#   subnet_id         = aws_subnet.public_subnet_2.id
#   allocation_id     = aws_eip.eip1.id
# }

#```````````
#NAT instance
#```````````
#Network interface
resource "aws_network_interface" "nat_interface" {
  subnet_id = aws_subnet.public_subnet_1.id
  source_dest_check = false
  security_groups = [var.nat_sg]

  tags = {
    Name = "NAT-instance-interface"
  }
}
#EC2 instance
resource "aws_instance" "nat_instance" {
  ami = var.nat_ami
  instance_type = "t2.micro"
  count = 1
  key_name = "3TierLab"
  network_interface {
    network_interface_id = aws_network_interface.nat_interface.id
    device_index = 0
  }
  iam_instance_profile = var.nat_iam_profile

  tags = {
    Name = "NAT-instance"
    Role = "NAT"
  }
}

#``````````
#Route53 config
#``````````
#we create a cname record since we are pointing to another domain
resource "aws_route53_record" "cname_record" {
  zone_id = var.route53_zone.zone_id
  name = "lab.${var.route53_zone.name}"
  type = "CNAME"
  ttl = "300"
  records = [var.frontend_dns_name]
}