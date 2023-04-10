### - Use this block to create a new service ---###

module "service" {
  source = "./modules/ecs_service"
  name   = "nginx"
  container_name = "nginx"
  cluster = aws_ecs_cluster.test.id
  subnet_id1 = aws_subnet.private.id
  subnet_id2 = aws_subnet.private2.id
  vpc_id = aws_vpc.test.id
  health_check_path = "/"
}

resource "aws_lb_listener" "prod" {
  load_balancer_arn = aws_lb.test.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = module.service.target_group_arn
    type             = "forward"
  }
}

### --- END of service block ---###