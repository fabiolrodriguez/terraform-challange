# Get local public IP
data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}

# Create a security group to allow traffic to alb
resource "aws_security_group" "alb" {
  name_prefix = "alb-sg"
  vpc_id      = aws_vpc.test.id
  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = ["${chomp(data.http.myip.body)}/32"]
  }
  
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["${chomp(data.http.myip.body)}/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "SG for interview_25 ALB"
  }
}

# Create an Application Load Balancer
resource "aws_lb" "test" {
  name               = "test-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = [aws_subnet.public.id,aws_subnet.public2.id]
  security_groups    = [aws_security_group.alb.id]
  tags = {
    Name = "ALB for interview_25"
  }
}

resource "aws_acm_certificate" "test" {
  domain_name       = "flrops.cloud"
  validation_method = "DNS"

  tags = {
    Name = "ACM Certificate for interview_25 ALB"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_zone" "flrops_cloud" {
  name = "flrops.cloud"
}

resource "aws_route53_record" "flrops_cloud_lb" {
  zone_id = aws_route53_zone.flrops_cloud.zone_id
  name    = "."
  type    = "A"
  alias {
    name    = aws_lb.test.dns_name
    zone_id = aws_lb.test.zone_id
    evaluate_target_health = true
  }
}