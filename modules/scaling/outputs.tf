output "bastion_ip" {
  value = aws_instance.bastion_host.public_ip
  description = "Bastion host public IP."
}