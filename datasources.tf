data "http" "myip" {
  url = "https://ipv4.icanhazip.com"
}

data "aws_ami" "frontend_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-2.0.2023*.0-x86_64-gp2"]
  }
}

data "aws_ami" "backend_ami" {
  most_recent = true
  owners      = ["099720109477"] #canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-2023*"]
  }
}

data "aws_ami" "nat_ami" {
  most_recent = true
  owners      = ["568608671756"] #fck-nat

  filter {
    name   = "name"
    values = ["fck-nat-amzn2-hvm-1.1.0-*-x86_64-ebs"]
  }
}

data "aws_route53_zone" "r53_zone" {
  name         = var.domain_name
  private_zone = false
}

data "aws_ecr_repository" "lambda_function" {
  name = "devopslab3-lambda"
}