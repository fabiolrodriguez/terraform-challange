resource "aws_appautoscaling_target" "test_to_target" {
  max_capacity = 5
  min_capacity = 1
  resource_id = "service/${var.cluster}/${aws_ecs_service.test.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace = "ecs"
}

resource "aws_appautoscaling_policy" "test_to_cpu" {
  name = "test-to-cpu"
  policy_type = "TargetTrackingScaling"
  resource_id = aws_appautoscaling_target.test_to_target.resource_id
  scalable_dimension = aws_appautoscaling_target.test_to_target.scalable_dimension
  service_namespace = aws_appautoscaling_target.test_to_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value = 65
  }
}