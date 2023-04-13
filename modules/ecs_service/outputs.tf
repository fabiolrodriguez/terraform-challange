output "service_name" {
  description = "The name of the ECS service"
  value       = aws_ecs_service.test.name
}

output "service_id" {
  description = "The ARN of the ECS service"
  value       = aws_ecs_service.test.id
}

output target_group_arn {
  value = aws_lb_target_group.test.arn
}

output security_group{
  value = aws_security_group.test.id
}