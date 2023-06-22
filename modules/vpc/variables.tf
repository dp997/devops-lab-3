variable "vpc_cidr_block" {
    type = string
    default = "10.0.0.0/16"
    description = "CIDR block for VPC"
}

variable "public_subnet_1_cidr_block" {
    type = string
    default =   "10.0.1.0/24"
    description = "CIDR block for public subnet #1"
}

variable "public_subnet_2_cidr_block" {
    type = string
    default =   "10.0.2.0/24"
    description = "CIDR block for public subnet #2"
}

variable "private_subnet_1_cidr_block" {
    type = string
    default =   "10.0.3.0/24"
    description = "CIDR block for private subnet #1"
}

variable "private_subnet_2_cidr_block" {
    type = string
    default =   "10.0.4.0/24"
    description = "CIDR block for private subnet #2"
}

variable "project_name" {
    type = string
}

variable "aws_region" {
    type = string
}

variable "nat_sg" {
    type = string
}

variable "nat_ami" {
    type = string
}

variable "nat_iam_profile" {
    type = string
}

variable "route53_zone" {
    type = object({
        zone_id = string
        name = string
    })
}

variable "frontend_dns_name" {
    type = string
}