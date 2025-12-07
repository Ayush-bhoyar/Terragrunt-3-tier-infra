resource "aws_lb" "External_lb" {
  name               = "External-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.external_lb_sg_id]
  subnets            = var.public_subnet_ids

  enable_deletion_protection = false

  tags = {
    Name    = "3-tier-external-lb-${var.environment}"
    Project = "3-tier-Infra"

  }
}

resource "aws_lb_target_group" "external_lb_tg" {
  name     = "Ext-lb-tg"
  port     = var.frontend_port
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  tags = {
    Name    = "3-tier-external-tg-${var.environment}"
    Project = "3-tier-Infra"

  }
}



resource "aws_lb_listener" "external_lb_listener" {
  load_balancer_arn = aws_lb.External_lb.arn
  port              = 80
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.external_lb_tg.arn

  }
}


resource "aws_lb" "Internal_lb" {
  name               = "Int-load-balancer"
  security_groups    = [var.internal_lb_sg_id]
  load_balancer_type = "application"
  internal           = true
  subnets            = var.private_subnet_ids

  tags = {
    Name    = "3-tier-internal-lb-${var.environment}"
    Project = "3-tier-Infra"

  }
}

resource "aws_lb_target_group" "internal_lb_tg" {
  name     = "Internal-lb-tg"
  port     = var.backend_port
  vpc_id   = var.vpc_id
  protocol = "HTTP"

  tags = {
    Name    = "3-tier-internal-lb-tg-${var.environment}"
    Project = "3-tier-Infra"

  }

}

resource "aws_lb_listener" "internal_lb_listener" {
  load_balancer_arn = aws_lb.Internal_lb.arn
  port              = 80
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.internal_lb_tg.arn
  }
}