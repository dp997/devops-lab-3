#`````````
#Frontend provisioning
#`````````
#Launch template
resource "aws_launch_template" "Frontend_LT" {
  name                   = "Frontend-LT"
  description            = "Launch Template Frontend"
  image_id               = var.frontend_ami
  instance_type          = "t2.micro"
  key_name               = "3TierLab"
  vpc_security_group_ids = [var.backend_sg]
  iam_instance_profile {
    arn = var.frontend_iam_profile
  }
  user_data = filebase64("${path.module}/ec2_userdata_frontend.sh")
  tags = {
    Name = "Frontend"
  }
}
#Auto scaling group
resource "aws_autoscaling_group" "frontend_asg" {
  name = "frontend-asg"
  launch_template {
    id      = aws_launch_template.Frontend_LT.id
    version = aws_launch_template.Frontend_LT.latest_version
  }
  vpc_zone_identifier       = [var.private_subnet_1, var.private_subnet_2]
  target_group_arns         = [var.Frontend_LB_TG]
  health_check_grace_period = 300
  health_check_type         = "ELB"
  min_size                  = 1
  max_size                  = 3
  desired_capacity          = 1
}
#Auto scaling policy
resource "aws_autoscaling_policy" "frontend_asg" {
  name                      = "frontend-asg-policy"
  autoscaling_group_name    = aws_autoscaling_group.frontend_asg.name
  policy_type               = "TargetTrackingScaling"
  estimated_instance_warmup = 300
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = "60"
  }

}
#``````````
#Backend provisioning
#``````````
#Launch template
resource "aws_launch_template" "Backend_LT" {
  name                   = "Backend-LT"
  description            = "Launch Template Backend"
  image_id               = var.backend_ami
  instance_type          = "t2.micro"
  key_name               = "3TierLab"
  vpc_security_group_ids = [var.backend_sg]
  user_data              = filebase64("${path.module}/ec2_userdata_backend.sh")
  tags = {
    Name = "Backend"
  }
  metadata_options {
    http_endpoint = "enabled"
  }
}
#Auto scaling group
resource "aws_autoscaling_group" "backend_asg" {
  name = "backend-asg"
  launch_template {
    id      = aws_launch_template.Backend_LT.id
    version = aws_launch_template.Backend_LT.latest_version
  }
  vpc_zone_identifier       = [var.private_subnet_1, var.private_subnet_2]
  target_group_arns         = [var.Backend_LB_TG]
  health_check_grace_period = 300
  health_check_type         = "ELB"
  min_size                  = 1
  max_size                  = 3
  desired_capacity          = 1
}
#`````````
#Bastion host
#`````````
resource "aws_instance" "bastion_host" {
  tags = {
    Name = "bastion-host"
  }
  ami                         = var.backend_ami
  instance_type               = "t2.micro"
  key_name                    = "3TierLab"
  subnet_id                   = var.public_subnet_1
  associate_public_ip_address = true
  vpc_security_group_ids      = [var.backend_sg]
}