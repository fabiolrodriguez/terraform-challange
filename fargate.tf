resource "aws_ecs_cluster" "test" {
  name = "test-cluster"
  tags = {
    Name = "Fargate cluster for interview_25"
  }
}

resource "aws_ecs_cluster_capacity_providers" "test" {
  cluster_name = aws_ecs_cluster.test.name

  capacity_providers = ["FARGATE"]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = "FARGATE"
  }
}