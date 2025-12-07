
resource "aws_launch_template" "backend_app_lt" {
  name_prefix            = "Backend-LT-"
  image_id               = var.backend_image_id
  instance_type          = var.backend_instance_type
  vpc_security_group_ids = [var.backend_app_sg_id]
  iam_instance_profile {
    name = var.instance_profile_name
  }

  user_data = base64encode(file("${path.module}/backend_script.sh"))

  tags = {
    Name    = "3-tier-app-backend-LT-${var.environment}"
    Project = "3-tier-Infra"

  }
}


resource "aws_autoscaling_group" "backend_app_asg" {
  desired_capacity          = 2
  max_size                  = 3
  min_size                  = 1
  health_check_grace_period = 300
  health_check_type         = "EC2"
  vpc_zone_identifier       = var.private_subnet_ids



  launch_template {
    id      = aws_launch_template.backend_app_lt.id
    version = "$Latest"
  }

  target_group_arns = [var.internal_lb_targetgrp_arn]



  tag {
    key                 = "Name"
    value               = "3-tier-backend-asg-${var.environment}"
    propagate_at_launch = true
  }

  tag {
    key                 = "Project"
    value               = "3-tier-Infra"
    propagate_at_launch = true
  }

}

resource "aws_launch_template" "frontend_app_lt" {
  name_prefix            = "Frontend-app-LT-"
  instance_type          = var.frontend_instance_type
  image_id               = var.frontend_image_id
  vpc_security_group_ids = [var.frontend_app_sg_id]
  iam_instance_profile {
    name = var.instance_profile_name
  }

  user_data = base64encode(file("${path.module}/frontendscript.sh"))

  tags = {
    Name    = "3-tier-frontend-lt-${var.environment}"
    Project = "3-tier-Infra"
  }

}

resource "aws_autoscaling_group" "frontend_app_asg" {
  name                = "Frontend-app-asg"
  max_size            = 3
  desired_capacity    = 2
  min_size            = 1
  vpc_zone_identifier = var.public_subnet_ids

  target_group_arns = [var.external_lb_targetgrp_arn]

  launch_template {
    id      = aws_launch_template.frontend_app_lt.id
    version = "$Latest"
  }


  tag {
    key                 = "Name"
    value               = "3-tier-frontend-asg-${var.environment}"
    propagate_at_launch = true
  }

  tag {
    key                 = "Project"
    value               = "3-tier-Infra"
    propagate_at_launch = true
  }


}