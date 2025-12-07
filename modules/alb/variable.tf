variable "external_lb_sg_id" {
  type = string
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "environment" {
  type = string
}

variable "frontend_port" {
  type = number
}

variable "vpc_id" {
  type = string
}

variable "internal_lb_sg_id" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "backend_port" {
  type = number
}