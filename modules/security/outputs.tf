output "frontend_sg" {
    value = aws_security_group.frontend_sg.id
}

output "backend_sg" {
    value = aws_security_group.backend_sg.id
}

output "database_sg" {
    value = aws_security_group.database_sg.id
}
output "nat_sg" {
    value = aws_security_group.nat_sg.id
}

output "frontend_iam_profile" {
    value = aws_iam_instance_profile.frontend_iam_profile.arn
}

output "nat_iam_profile" {
    value = aws_iam_instance_profile.nat_iam_profile.name
}

output "lambda_iam_role" {
    value = aws_iam_role.lambda_read.arn
}