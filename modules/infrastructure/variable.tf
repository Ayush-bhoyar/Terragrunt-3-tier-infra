variable "main_cidr_block" {
  description = "The value  of Main CIDR block"
  type        = string
}

variable "environment" {
  description = "The value of environment"
  type        = string
}

variable "public_subnet_count" {
  description = "The total no of public subnet"
  type        = number
}


variable "private_subnet_count" {
  description = "The total no of private subnet"
  type        = number
}

variable "frontend_port" {
  type = number
}

variable "backend_port" {
  type = number
}


variable "frontend_image_id" {
  type = string
}

variable "frontend_instance_type" {
  type = string
}

variable "backend_instance_type" {
  type = string
}

variable "backend_image_id" {
  type = string
}

variable "vault_address" {
  type        = string
  description = "Vault server address"
}

variable "vault_role_id" {
  type        = string
  description = "Vault AppRole role ID"
  sensitive   = true
}

variable "vault_secret_id" {
  type        = string
  description = "Vault AppRole secret ID"
  sensitive   = true
}


variable "engine_name" {
  type        = string
  description = "Rds engine name"
}

variable "engine_version" {
  type = string
}

variable "db_instance_class" {
  type = string
}

variable "db_name" {
  type = string
}

variable "aws_region" {
  type        = string
  description = "AWS region for resources"
  default     = "ap-south-1"
}