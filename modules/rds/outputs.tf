output "db_hostname" {
  value = aws_db_instance.postgres1.address
}

output "db_port" {
    value = aws_db_instance.postgres1.port
}

output "db_name" {
    value = aws_db_instance.postgres1.db_name
}

output "db_username_lambda" {
  value = postgresql_role.lambda_role.name
}

output "db_username_webapp" {
  value = postgresql_role.webapp_role.name
}