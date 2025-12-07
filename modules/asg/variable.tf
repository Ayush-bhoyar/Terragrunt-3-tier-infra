variable "public_subnet_ids" {
  type = list(string)
}

variable "backend_instance_type" {
  type = string
}

variable "backend_image_id" {
  type = string
}

variable "availability_zones" {
  type = list(string)
}

variable "backend_app_sg_id" {
  type = string
}

variable "environment" {
  type = string
}

variable "instance_profile_name" {
  type = string
}

variable "internal_lb_targetgrp_arn" {
  type = string
}

variable "frontend_image_id" {
  type = string
}

variable "frontend_instance_type" {
  type = string
}

variable "frontend_app_sg_id" {
  type = string
}

variable "external_lb_targetgrp_arn" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

