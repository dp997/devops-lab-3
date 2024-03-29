terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }

    postgresql = {
      source = "cyrilgdn/postgresql"
    }
  }
}

resource "aws_db_subnet_group" "postgres1" {
  name = "main"
  subnet_ids = [var.public_subnet_1, var.public_subnet_2]
}

resource "aws_db_instance" "postgres1" {
    allocated_storage = 20
    db_name = "datasets"
    engine = "postgres"
    engine_version = "14.7"
    instance_class = "db.t3.micro"
    username = "postgres"
    password = var.db_password
    multi_az = false
    iam_database_authentication_enabled = true
    identifier = "${var.project_name}-db"
    network_type = "IPV4"
    publicly_accessible = true
    db_subnet_group_name = aws_db_subnet_group.postgres1.name
    vpc_security_group_ids = [var.database_sg]
    availability_zone = "${var.aws_region}a"
    skip_final_snapshot = true
}

provider "postgresql" {
  host             = aws_db_instance.postgres1.address
  port             = aws_db_instance.postgres1.port
  username         = aws_db_instance.postgres1.username
  password         = var.db_password
  expected_version = aws_db_instance.postgres1.engine_version
  sslmode          = "require"
  superuser = false
}

resource "postgresql_role" "lambda_role" {
  name = "lambda"
  login = true
  roles = ["rds_iam"]
  depends_on = [aws_db_instance.postgres1]
  superuser = false
  skip_reassign_owned = true
}

resource "postgresql_role" "webapp_role" {
  name = "webapp"
  login = true
  roles = ["rds_iam"]
  superuser = false
  depends_on = [postgresql_role.lambda_role]
  skip_reassign_owned = true
}

resource "postgresql_default_privileges" "webapp_readtable" {
  role     = postgresql_role.webapp_role.name
  database = aws_db_instance.postgres1.db_name
  schema   = "public"

  owner       = postgresql_role.lambda_role.name
  object_type = "table"
  privileges  = ["SELECT"]
}