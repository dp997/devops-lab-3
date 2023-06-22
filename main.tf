#`````````
#Pet name
#`````````

resource "random_pet" "unique_id" {
  prefix = var.project_name
  length = 2
}

#`````````
#Locals
#`````````
locals {
  lambda_script_path = "${path.root}/lambda_function.py"
  layer_zip_path     = "${path.root}/lambda_layer.zip"
  layer_name         = "lambda_layer"
  requirements_path  = "${path.root}/lambda_requirements.txt"
}

#`````````
#Lambda packaging
#`````````
variable "lambda_zip_path" {
  type    = string
  default = "./lambda_function.zip"
}

resource "null_resource" "lambda_function" {
  triggers = {
    function = filesha1(local.lambda_script_path)
  }

  provisioner "local-exec" {
    command = <<EOT
      zip ${var.lambda_zip_path} ${local.lambda_script_path}
    EOT
  }

  depends_on = [null_resource.lambda_layer]
}

resource "null_resource" "lambda_layer" {
  triggers = {
    requirements = filesha1(local.requirements_path)
  }

  provisioner "local-exec" {
    command = <<EOT
      pip install -r ${local.requirements_path} -t python/     
    EOT
  }

  provisioner "local-exec" {
    command = <<EOT
      zip -r ${local.layer_zip_path} python/
    EOT
  }
}

#`````````
#Modules
#`````````
#VPC
module "vpc" {
  source = "./modules/vpc"
  #global outputs
  project_name = random_pet.unique_id.id
  aws_region   = var.aws_region
  nat_ami      = data.aws_ami.nat_ami.id
  route53_zone = {
    zone_id = data.aws_route53_zone.r53_zone.zone_id
    name    = data.aws_route53_zone.r53_zone.name
  }
  #security outputs
  nat_sg          = module.security.nat_sg
  nat_iam_profile = module.security.nat_iam_profile
  #load balancer outputs
  frontend_dns_name = module.load_balancers.frontend_dns_name
}

#Security
module "security" {
  source = "./modules/security"
  #global outputs
  my_ip = "${chomp(data.http.myip.response_body)}/32"
  #vpc outputs
  vpc_id         = module.vpc.vpc_id
  vpc_cidr_block = module.vpc.vpc_cidr_block
}

#Load balancers
module "load_balancers" {
  source = "./modules/load_balancers"
  #vpc outputs
  vpc_id           = module.vpc.vpc_id
  public_subnet_1  = module.vpc.public_subnet_1
  public_subnet_2  = module.vpc.public_subnet_2
  private_subnet_1 = module.vpc.private_subnet_1
  private_subnet_2 = module.vpc.private_subnet_2
  #security outputs
  frontend_sg = module.security.frontend_sg
  backend_sg  = module.security.backend_sg
}

#Instances and scaling
module "scaling" {
  source = "./modules/scaling"
  #global outputs
  frontend_ami = data.aws_ami.frontend_ami.id
  backend_ami  = data.aws_ami.backend_ami.id
  #vpc outputs
  vpc_id           = module.vpc.vpc_id
  public_subnet_1  = module.vpc.public_subnet_1
  public_subnet_2  = module.vpc.public_subnet_2
  private_subnet_1 = module.vpc.private_subnet_1
  private_subnet_2 = module.vpc.private_subnet_2
  #security outputs
  frontend_sg          = module.security.frontend_sg
  backend_sg           = module.security.backend_sg
  frontend_iam_profile = module.security.frontend_iam_profile
  #load balancer outputs
  Backend_LB_TG  = module.load_balancers.Backend_LB_TG
  Frontend_LB_TG = module.load_balancers.Frontend_LB_TG
}

#S3
module "s3" {
  depends_on = [null_resource.lambda_layer, null_resource.lambda_function]
  source     = "./modules/s3"
  #global outputs
  unique_id = random_pet.unique_id.id
  #vpc outputs
  #security outputs

}
#RDS
module "rds" {
  source = "./modules/rds"
  #global outputs
  project_name = random_pet.unique_id.id
  db_password  = var.db_password
  aws_region   = var.aws_region
  #vpc
  public_subnet_1  = module.vpc.public_subnet_1
  public_subnet_2  = module.vpc.public_subnet_2
  private_subnet_1 = module.vpc.private_subnet_1
  private_subnet_2 = module.vpc.private_subnet_2
  #security
  frontend_sg = module.security.frontend_sg
  backend_sg  = module.security.backend_sg
  database_sg = module.security.database_sg

}
#Lambda
module "lambda" {
  depends_on = [module.s3]
  source     = "./modules/lambda"
  #global outputs
  lambda_zip_path = var.lambda_zip_path
  #vpc outputs
  private_subnet1 = module.vpc.private_subnet_1
  #security outputs
  lambda_role = module.security.lambda_iam_role
  backend_sg  = module.security.backend_sg
  #db outputs
  db_hostname = module.rds.db_hostname
  db_port     = module.rds.db_port
  db_name     = module.rds.db_name
  db_username = module.rds.db_username
  #s3 outputs
  dataset_bucket = module.s3.dataset_bucket
  lambda_bucket  = module.s3.lambda_bucket
}

#`````````
#Variables
#`````````
variable "project_name" {
  type        = string
  default     = "devopslab3"
  description = "Project name. Affects names."
}

variable "aws_region" {
  type        = string
  default     = "us-east-1"
  description = "Region to deploy."
}

variable "domain_name" {
  type        = string
  default     = "dsrv.tk"
  description = "Domain name in hosted Route53 zone."
}

variable "db_password" {
  type        = string
  description = "Provide admin password to RDS instance."
}
#``````````
#Outputs
#``````````

output "frontend_dns_name" {
  value       = module.load_balancers.frontend_dns_name
  description = "Frontend load balancer DNS name"
}

output "bastion_host_ip" {
  value       = module.scaling.bastion_ip
  description = "Bastion host public IP"
}

output "route53_address" {
  value       = module.vpc.route53_address
  description = "Address pointing to frontend load balancer"
}


