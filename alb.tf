# Defining a Target Group for the Application Load Balancer
resource "aws_lb_target_group" "web-tgroup" {
  name        = "web-tgroup"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = aws_vpc.demo-vpc.id

  health_check {
    enabled             = true
    interval            = 10
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

# Attaching Autoscaling Policy as ALB Target
resource "aws_autoscaling_attachment" "webauto" {
  autoscaling_group_name = aws_autoscaling_group.web.id
  lb_target_group_arn    = aws_lb_target_group.web-tgroup.arn
}

#Creating the Application Load Balancer
resource "aws_lb" "application-lb-web" {
  name               = "web-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = [for subnet in aws_subnet.public : subnet.id]
  security_groups    = [aws_security_group.web.id]
  ip_address_type    = "ipv4"

  tags = {
    name = "web-alb"
  }
}
#Creating a Listener for the ALB
resource "aws_lb_listener" "alb-listener" {
  load_balancer_arn = aws_lb.application-lb-web.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web-tgroup.arn
  }
}
