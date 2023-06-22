variable "vpc_id" {
    type = string
}

variable "public_subnet_1" {
    
    type = string
}

variable "public_subnet_2" {
    
    type = string
}

variable "private_subnet_1" {
    
    type = string
}

variable "private_subnet_2" {
    
    type = string
}

variable "frontend_sg" {
    type = string
}

variable "backend_sg" {
    type = string
}

variable "frontend_iam_profile" {
    type = string
}

variable "Frontend_LB_TG" {
    type = string
}

variable "Backend_LB_TG" {
    type = string
}

variable "frontend_ami" {
    type = string
}

variable "backend_ami" {
    type = string
}