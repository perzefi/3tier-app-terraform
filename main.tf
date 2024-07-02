terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.55.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}



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

/*
    resource "aws_db_instance" "mysql" {
    allocated_storage           = 10
    storage_type                = "gp2"
    engine                      = "mysql"
    engine_version              = "8.0"
    instance_class              = "db.t3.micro"
    db_name                     = "myrdstestmysql"
    username                    = "admin"
    password                    = "admin123"
    parameter_group_name        = "default.mysql8.0"
    skip_final_snapshot         = true
    db_subnet_group_name        = aws_db_subnet_group.mysql.name
    } */