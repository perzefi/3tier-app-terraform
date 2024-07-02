#Creating a ec2 launch template for the web tier  
resource "aws_launch_template" "web" {
  name                   = "AutoSG_Template"
  image_id               = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.web.id]
  user_data              = filebase64("${path.module}/user.sh")
  lifecycle {
    create_before_destroy = true
  }
}

#Creating autoscaling group for the web tier(min insstance , desired 2, and max 5)
resource "aws_autoscaling_group" "web" {
  name                 = "webtier-autoscaling-group"
  desired_capacity     = 2
  max_size             = 5
  min_size             = 2
  health_check_type    = "EC2"
  termination_policies = ["OldestInstance"]
  vpc_zone_identifier  = aws_subnet.public.*.id
  launch_template {
    id      = aws_launch_template.web.id
    version = "$Latest"
  }
}

#Defining a Autoscaling policy for WEB instances(if avg cpu > 50%, scale up)
resource "aws_autoscaling_policy" "web_cpu" {
  name                   = "avg-cpu-policy-greater"
  policy_type            = "TargetTrackingScaling"
  autoscaling_group_name = aws_autoscaling_group.web.id
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = var.cpu_threshold
  }
}

#Creating a ec2 launch template for the web tier  
resource "aws_launch_template" "app" {
  name                   = "appLaunch_Template"
  image_id               = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.app.id]
  lifecycle {
    create_before_destroy = true
  }
}

#Creating autoscaling group for the APP tier 
resource "aws_autoscaling_group" "app" {
  name                 = "app-autoscaling-group"
  desired_capacity     = 2
  max_size             = 5
  min_size             = 2
  health_check_type    = "EC2"
  termination_policies = ["OldestInstance"]
  vpc_zone_identifier  = [aws_subnet.private[0].id, aws_subnet.private[1].id]
  launch_template {
    id      = aws_launch_template.app.id
    version = "$Latest"
  }
}

#Defining a Autoscaling policy for APP instances(if avg cpu > 50%, scale up)
resource "aws_autoscaling_policy" "app_cpu" {
  name                   = "app_avg-cpu-policy-greater"
  policy_type            = "TargetTrackingScaling"
  autoscaling_group_name = aws_autoscaling_group.app.id
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = var.cpu_threshold
  }
}

