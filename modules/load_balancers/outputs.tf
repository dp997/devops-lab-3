output "frontend_dns_name" {
  value       = aws_lb.Frontend_LB.dns_name
  description = "DNS name of the main server instance."
}

output "Frontend_LB_TG" {
  value = aws_lb_target_group.Frontend_LB_TG.arn
}

output "Backend_LB_TG" {
  value = aws_lb_target_group.Backend_LB_TG.arn
}