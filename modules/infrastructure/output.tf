output "external_alb_dns_name" {
  value       = module.ALB.external_lb_dns_name
  description = "DNS name of the external ALB"
}

output "internal_alb_dns_name" {
  value       = module.ALB.internal_lb_dns_name
  description = "DNS name of the internal ALB"
}

output "rds_endpoint" {
  value       = module.RDS.rds_endpoint
  description = "RDS instance endpoint address"
}

