variable "lambda_role" {
    type = string
}

# variable "lambda_zip_path" {
#     type = string
# }

variable "db_hostname" {
    type = string
}

variable "db_port" {
    type = string
}

variable "db_username" {
    type = string
}

variable "db_name" {
    type = string
}

variable "dataset_bucket" {
    type = string
}

# variable "lambda_bucket" {
#     type = string
# }

variable "private_subnet1" {
    type = string
}

variable "private_subnet2" {
    type = string
}

variable "backend_sg" {
    type = string
}

variable "lambda_function_ecr" {
    type = string
}