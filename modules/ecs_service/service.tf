

# Create a task definition for the ECS service
resource "aws_ecs_task_definition" "test" {
  family                   = var.name
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.cpu
  memory                   = var.memory
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn


  container_definitions = jsonencode([
    {
      name: "${var.container_name}",
      image: "${var.image}",
      network_mode: "awsvpc",
      essential: true,
      cpu: "${var.cpu}",
      memory: "${var.memory}",
      health_check_path : "${var.health_check_path}",
      portMappings: [
          {
          containerPort: "${var.container_port}",
          hostPort: "${var.container_port}",
          }
      ],
      logConfiguration: {
          logDriver: "awslogs",
          options: {
              "awslogs-create-group": "true",
              "awslogs-group": "/ecs/interview-25",
              "awslogs-region": "us-east-2",
              "awslogs-stream-prefix": "ecs"
          }
      }
    }
  ])
}

# Create a security group to allow traffic to the container
resource "aws_security_group" "test" {
  name_prefix = "${var.name}-sg"
  vpc_id      = var.vpc_id
  ingress {
    from_port = var.container_port
    to_port   = var.container_port
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create an ECS service to run on the cluster
resource "aws_ecs_service" "test" {
  name               = "${var.name}-service"
  cluster            = var.cluster.id
  task_definition    = aws_ecs_task_definition.test.arn
  desired_count      = var.desired_count
  launch_type        = "FARGATE"

  network_configuration {
    subnets = [
      var.subnet_id1,
      var.subnet_id2
    ]
    security_groups = aws_security_group.test.*.id
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.test.arn
    container_name   = var.container_name
    container_port   = var.container_port
  }
  lifecycle {
    create_before_destroy = true
    ignore_changes        = [task_definition]
  }
}

# Create a target group for the ALB to route traffic to the ECS service
resource "aws_lb_target_group" "test" {
  name     = "${var.name}-target-group"
  port     = var.container_port
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  target_type = "ip"

  health_check {
    path = "${var.health_check_path}"
  }
}
