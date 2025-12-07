variable "vpc_id" {
  type        = string
  description = "main vpc id"
}

variable "environment" {
  type = string
}

variable "frontend_port" {
  type = string
}

variable "backend_port" {
  type = string
}