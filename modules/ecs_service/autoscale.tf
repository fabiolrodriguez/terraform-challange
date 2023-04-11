resource "aws_appautoscaling_target" "test_to_target" {
  max_capacity = 10
  min_capacity = 1
  resource_id = "service/${var.cluster.name}/${aws_ecs_service.test.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace = "ecs"
  role_arn = aws_iam_role.ecs-autoscale-role.arn
}

resource "aws_appautoscaling_policy" "ecs_scale_up" {
  name = "scale-up"
  policy_type = "StepScaling"
  resource_id = aws_appautoscaling_target.test_to_target.resource_id
  scalable_dimension = aws_appautoscaling_target.test_to_target.scalable_dimension
  service_namespace = aws_appautoscaling_target.test_to_target.service_namespace

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 65
    metric_aggregation_type = "Maximum"

    step_adjustment {
      metric_interval_upper_bound = 0
      scaling_adjustment          = 1
    }
  }
}

resource "aws_appautoscaling_policy" "ecs_scale_down" {
  name               = "scale-down"
  policy_type        = "StepScaling"
  resource_id        = aws_appautoscaling_target.test_to_target.resource_id
  scalable_dimension = aws_appautoscaling_target.test_to_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.test_to_target.service_namespace

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 40
    metric_aggregation_type = "Maximum"

    step_adjustment {
      metric_interval_upper_bound = 0
      scaling_adjustment          = -1
    }
  }
}

resource "aws_cloudwatch_metric_alarm" "up" {
  actions_enabled     = true
  alarm_actions       = [aws_appautoscaling_policy.ecs_scale_up.arn]
  alarm_name          = "terraform-cpu-up"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  statistic           = "Average"
  period              = 120
  threshold           = 65

  dimensions = {
    ClusterName = var.cluster.name
    ServiceName = aws_ecs_service.test.name
  }
}

resource "aws_cloudwatch_metric_alarm" "down" {
  actions_enabled     = true
  alarm_actions       = [aws_appautoscaling_policy.ecs_scale_down.arn]
  alarm_name          = "terraform-cpu-down"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  statistic           = "Average"
  period              = 120
  threshold           = 40

  dimensions = {
    ClusterName = var.cluster.name
    ServiceName = aws_ecs_service.test.name
  }
}