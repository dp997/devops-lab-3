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
  update_default_version = true
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
  update_default_version = true
  # user_data              = filebase64("${path.module}/ec2_userdata_backend.sh")
  iam_instance_profile {
    arn = var.backend_iam_profile
  }
  user_data = "${base64encode(<<EOF
#!/bin/bash
sudo echo 'DBHOSTNAME="${var.db_hostname}"' | sudo tee -a /etc/environment
sudo echo 'DBPORT="${var.db_port}"' | sudo tee -a /etc/environment
sudo echo 'DBUSERNAME="${var.db_username}"' | sudo tee -a /etc/environment
sudo echo 'DBNAME="${var.db_name}"' | sudo tee -a /etc/environment
TOKEN=`curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600"`
sudo echo "REGION=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/placement/region)" | sudo tee -a /etc/environment
sudo apt-get update
sudo apt-get install -y git python3.10 python3-pip
sudo mkdir devops-lab-3-webapp
cd devops-lab-3-webapp
sudo git init
sudo git pull https://github.com/dp997/devops-lab-3-webapp.git
sudo pip install -r requirements.txt
sudo python3.10 app.py
  EOF
  )}"
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
  vpc_security_group_ids      = [var.frontend_sg]
}