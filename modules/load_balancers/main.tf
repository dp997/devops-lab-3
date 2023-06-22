#``````````
#Frontend load balancer
#``````````
#Target group
resource "aws_lb_target_group" "Frontend_LB_TG" {
  name        = "Frontend-TG"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = var.vpc_id
}
#Load balancer
resource "aws_lb" "Frontend_LB" {
  name               = "Frontend-LB"
  internal           = false
  subnets            = [var.public_subnet_1, var.public_subnet_2]
  ip_address_type    = "ipv4"
  load_balancer_type = "application"
  security_groups    = [var.frontend_sg]
}
#Listener
resource "aws_lb_listener" "Frontend_LB_listener" {
  load_balancer_arn = aws_lb.Frontend_LB.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.Frontend_LB_TG.arn
  }
}
#``````````
#Backend load balancer
#``````````
#Target group
resource "aws_lb_target_group" "Backend_LB_TG" {
  name        = "Backend-TG"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = var.vpc_id

  health_check {
    port = 80
    path = "/"
  }
}
#Load balancer
resource "aws_lb" "Backend_LB" {
  name               = "Backend-LB"
  load_balancer_type = "application"
  subnets            = [var.private_subnet_1, var.private_subnet_2]
  internal           = true
  ip_address_type    = "ipv4"
  security_groups    = [var.backend_sg]
}
#Listener
resource "aws_lb_listener" "Backend_LB_listener" {
  load_balancer_arn = aws_lb.Backend_LB.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.Backend_LB_TG.arn
  }
}

