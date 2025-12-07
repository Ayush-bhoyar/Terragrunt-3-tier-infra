# envs/dev/terragrunt.hcl
terraform {
  source = "../../modules"
}

include {
  path = find_in_parent_folders()
}

inputs = {
  aws_region            = "us-east-1"
  environment           = "dev"
  frontend_instance_type = "t3.micro"
  backend_instance_type  = "t3.micro"
  frontend_image_id      = "ami-0cae6d6fe6048ca2c"
  backend_image_id       = "ami-0cae6d6fe6048ca2c"
  frontend_port          = 80
  backend_port           = 8080
  main_cidr_block        = "10.0.0.0/16"
  public_subnet_count    = 2
  private_subnet_count   = 2
  db_instance_class      = "db.t3.micro"
  db_name                = "mydb"
  engine_name            = "mysql"
  engine_version         = "8.0"
  # Vault credentials from environment variables
  vault_address          = get_env("VAULT_ADDR", "")
  vault_role_id          = get_env("VAULT_ROLE_ID", "")
  vault_secret_id        = get_env("VAULT_SECRET_ID", "")
}
