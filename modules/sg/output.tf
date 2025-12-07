output "external_lb_sg_id" {
  value = aws_security_group.external_lb_sg.id
}

output "frontend_app_sg_id" {
  value = aws_security_group.frontend_app_sg.id
}

output "internal_lb_sg_id" {
  value = aws_security_group.internal_lb_sg.id
}

output "backend_app_sg_id" {
  value = aws_security_group.backend_app_sg.id
}

output "db_sg_id" {
  value = aws_security_group.db_sg.id
}

