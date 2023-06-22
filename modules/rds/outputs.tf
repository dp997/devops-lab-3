output "db_hostname" {
  value = aws_db_instance.postgres1.address
}

output "db_port" {
    value = aws_db_instance.postgres1.port
}

output "db_name" {
    value = aws_db_instance.postgres1.db_name
}

output "db_username" {
  value = "lambda"
}