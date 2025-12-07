# Root module that calls infrastructure
# This allows Terragrunt to download the entire modules directory
# while keeping all module paths working correctly

module "infrastructure" {
  source = "./infrastructure"
  
  # Pass through all variables
  aws_region            = var.aws_region
  environment           = var.environment
  frontend_instance_type = var.frontend_instance_type
  backend_instance_type  = var.backend_instance_type
  frontend_image_id      = var.frontend_image_id
  backend_image_id       = var.backend_image_id
  frontend_port          = var.frontend_port
  backend_port           = var.backend_port
  main_cidr_block        = var.main_cidr_block
  public_subnet_count    = var.public_subnet_count
  private_subnet_count   = var.private_subnet_count
  db_instance_class      = var.db_instance_class
  db_name                = var.db_name
  engine_name            = var.engine_name
  engine_version         = var.engine_version
  vault_address          = var.vault_address
  vault_role_id          = var.vault_role_id
  vault_secret_id        = var.vault_secret_id
}

# Pass through outputs
output "external_alb_dns_name" {
  value = module.infrastructure.external_alb_dns_name
}

output "internal_alb_dns_name" {
  value = module.infrastructure.internal_alb_dns_name
}

output "rds_endpoint" {
  value = module.infrastructure.rds_endpoint
}

