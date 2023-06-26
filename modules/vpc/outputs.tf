output "vpc_id" {
  description = "VPC id"
  value = aws_vpc.VPC.id
}

output "vpc_cidr_block" {
    value = aws_vpc.VPC.cidr_block
}
output "public_subnet_1" {
    
    value = aws_subnet.public_subnet_1.id
}

output "public_subnet_2" {
    
    value = aws_subnet.public_subnet_2.id
}

output "private_subnet_1" {
    
    value = aws_subnet.private_subnet_1.id
}

output "private_subnet_2" {
    
    value = aws_subnet.private_subnet_2.id
}

output "route53_address" {
    
    value = aws_route53_record.frontend_record.name
}
