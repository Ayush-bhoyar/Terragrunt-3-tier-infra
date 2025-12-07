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


