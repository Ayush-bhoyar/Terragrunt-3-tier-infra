output "external_lb_tg_arn" {
  value = aws_lb_target_group.external_lb_tg.arn
}

output "internal_lb_tg_arn" {
  value = aws_lb_target_group.internal_lb_tg.arn
}

output "internal_lb_arn" {
  value = aws_lb.Internal_lb.arn
}

output "external_lb_arn" {
  value = aws_lb.External_lb.arn
}

output "external_lb_dns_name" {
  value       = aws_lb.External_lb.dns_name
  description = "DNS name of the external ALB"
}

output "internal_lb_dns_name" {
  value       = aws_lb.Internal_lb.dns_name
  description = "DNS name of the internal ALB"
}
