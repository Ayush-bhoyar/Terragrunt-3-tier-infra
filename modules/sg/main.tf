##############################
# External LB SG
##############################
resource "aws_security_group" "external_lb_sg" {
  vpc_id = var.vpc_id
  name   = "External-loadbalancer-sg"

  ingress {
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "tcp"
  }

  # open egress for all (safe and simple)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "3-tier-external-lb-${var.environment}"
    Project = "3-tier-Infra"
  }
}

##############################
# Frontend App SG
##############################
resource "aws_security_group" "frontend_app_sg" {
  vpc_id = var.vpc_id
  name   = "Frontend-app-sg"

  # ingress rule referencing external LB SG
  # move this reference to a separate rule resource below
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "3-tier-frontend-app-sg-${var.environment}"
    Project = "3-tier-Infra"
  }
}

resource "aws_security_group_rule" "frontend_ingress_from_external_lb" {
  type                     = "ingress"
  from_port                = var.frontend_port
  to_port                  = var.frontend_port
  protocol                 = "tcp"
  security_group_id        = aws_security_group.frontend_app_sg.id
  source_security_group_id = aws_security_group.external_lb_sg.id
}

##############################
# Internal LB SG
##############################
resource "aws_security_group" "internal_lb_sg" {
  vpc_id = var.vpc_id
  name   = "Internal-lb-sg"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "3-tier-internal-lb-sg-${var.environment}"
    Project = "3-tier-Infra"
  }
}

resource "aws_security_group_rule" "internal_ingress_from_frontend" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = aws_security_group.internal_lb_sg.id
  source_security_group_id = aws_security_group.frontend_app_sg.id
}

##############################
# Backend App SG
##############################
resource "aws_security_group" "backend_app_sg" {
  vpc_id = var.vpc_id
  name   = "Backend-app-sg"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "3-tier-backend-app-sg-${var.environment}"
    Project = "3-tier-Infra"
  }
}

resource "aws_security_group_rule" "backend_ingress_from_internal_lb" {
  type                     = "ingress"
  from_port                = var.backend_port
  to_port                  = var.backend_port
  protocol                 = "tcp"
  security_group_id        = aws_security_group.backend_app_sg.id
  source_security_group_id = aws_security_group.internal_lb_sg.id
}

##############################
# Database SG
##############################
resource "aws_security_group" "db_sg" {
  vpc_id = var.vpc_id
  name   = "Database-sg"

  tags = {
    Name    = "3-tier-db-sg-${var.environment}"
    Project = "3-tier-Infra"
  }
}

resource "aws_security_group_rule" "db_ingress_from_backend" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  security_group_id        = aws_security_group.db_sg.id
  source_security_group_id = aws_security_group.backend_app_sg.id
}
