variable "project_name" {
    type = string
}

variable "db_password" {
    type = string
}

variable "frontend_sg" {
    type = string
}

variable "backend_sg" {
    type = string
}

variable "database_sg" {
    type = string
}

variable "aws_region" {
  type        = string
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