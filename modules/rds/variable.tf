variable "private_subnet_ids" {
  type = list(string)
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

variable "db_sg_ids" {
  type = list(string)
}

variable "environment" {
  type = string
}
