# Allow Terraform to read the RDS secret
path "kv/data/rds-secret" {
  capabilities = ["read"]
}

path "kv/metadata/rds-secret" {
  capabilities = ["read"]
}

# REQUIRED: Allow Terraform to create child tokens
path "auth/token/create" {
  capabilities = ["update"]
}

