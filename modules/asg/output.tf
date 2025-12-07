output "Backend_asg_arn" {
  value = aws_autoscaling_group.backend_app_asg.arn
}

output "Frontend_asg_arn" {
  value = aws_autoscaling_group.frontend_app_asg.arn
}

output "Backend_lt_arn" {
  value = aws_launch_template.backend_app_lt.arn
}

output "Frontend_lt_arn" {
  value = aws_launch_template.frontend_app_lt.arn
}