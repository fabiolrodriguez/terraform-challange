### - Use this block to create a new service ---###

module "service" {
  source = "./modules/ecs_service"
  name   = "nginx"
  container_name = "nginx"
  # image = "416572346136.dkr.ecr.us-east-2.amazonaws.com/test-nginx:latest"
  cluster = aws_ecs_cluster.test
  subnet_id1 = aws_subnet.private.id
  subnet_id2 = aws_subnet.private2.id
  vpc_id = aws_vpc.test.id
  health_check_path = "/"
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.test.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "redirect"
    redirect {
      protocol        = "HTTPS"
      port            = "443"
      status_code     = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.test.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"

  default_action {
    target_group_arn = module.service.target_group_arn
    type             = "forward"
  }

  certificate_arn = aws_acm_certificate.test.arn
}

resource "aws_lb_listener_certificate" "https" {
  listener_arn    = aws_lb_listener.https.arn
  certificate_arn = aws_acm_certificate.test.arn
}

### --- END of service block ---###