resource "aws_db_subnet_group" "mysql_subnet_grp" {
  name       = "main"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name = "My DB subnet group"
  }
}


data "vault_kv_secret_v2" "rds_secret" {
  mount = "kv"         # Your KV engine mount path
  name  = "rds-secret" # Your secret path under kv/
}


resource "aws_db_instance" "mysql_rds" {
  allocated_storage      = 10
  db_name                = var.db_name
  engine                 = var.engine_name
  engine_version         = var.engine_version
  instance_class         = var.db_instance_class
  username               = data.vault_kv_secret_v2.rds_secret.data["username"]
  password               = data.vault_kv_secret_v2.rds_secret.data["password"]
  storage_type           = "gp2"
  parameter_group_name   = "default.${var.engine_name}${var.engine_version}"
  skip_final_snapshot    = true
  vpc_security_group_ids = var.db_sg_ids
  db_subnet_group_name   = aws_db_subnet_group.mysql_subnet_grp.name

  tags = {
    Name        = "rds-${var.environment}"
    Environment = var.environment
  }

}