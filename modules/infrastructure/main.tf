module "VPC" {
  source               = "../vpc"
  public_subnet_count  = var.public_subnet_count
  private_subnet_count = var.private_subnet_count
  main_cidr_block      = var.main_cidr_block
  environment          = var.environment
}

module "SG" {
  source        = "../sg"
  vpc_id        = module.VPC.Main_vpc_id
  backend_port  = var.backend_port
  frontend_port = var.frontend_port
  environment   = var.environment
}

module "ALB" {
  source             = "../alb"
  environment        = var.environment
  public_subnet_ids  = module.VPC.public_subnet_ids
  private_subnet_ids = module.VPC.private_subnet_ids
  backend_port       = var.backend_port
  frontend_port      = var.frontend_port
  vpc_id             = module.VPC.Main_vpc_id
  external_lb_sg_id  = module.SG.external_lb_sg_id
  internal_lb_sg_id  = module.SG.internal_lb_sg_id

}

module "IAM" {
  source      = "../iam"
  environment = var.environment
}

module "ASG" {
  source                    = "../asg"
  environment               = var.environment
  instance_profile_name     = module.IAM.ec2_instance_profile_name
  external_lb_targetgrp_arn = module.ALB.external_lb_tg_arn
  internal_lb_targetgrp_arn = module.ALB.internal_lb_tg_arn
  private_subnet_ids        = module.VPC.private_subnet_ids
  public_subnet_ids         = module.VPC.public_subnet_ids
  frontend_instance_type    = var.frontend_instance_type
  frontend_image_id         = var.frontend_image_id
  backend_image_id          = var.backend_image_id
  backend_instance_type     = var.backend_instance_type
  frontend_app_sg_id        = module.SG.frontend_app_sg_id
  backend_app_sg_id         = module.SG.backend_app_sg_id
  availability_zones        = module.VPC.availability_zones
}

module "RDS" {
  source             = "../rds"
  environment        = var.environment
  private_subnet_ids = module.VPC.private_subnet_ids
  db_sg_ids          = [module.SG.db_sg_id]

  engine_name       = var.engine_name
  engine_version    = var.engine_version
  db_instance_class = var.db_instance_class
  db_name           = var.db_name
}