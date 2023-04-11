resource "aws_network_acl" "load_balancer" {
  vpc_id = aws_vpc.test.id
  subnet_ids = [
    aws_subnet.public.id,
    aws_subnet.public2.id]
}

resource "aws_network_acl" "ecs_task" {
  vpc_id = aws_vpc.test.id
  subnet_ids = [
    aws_subnet.private.id,
    aws_subnet.private2.id]
}

resource "aws_network_acl_rule" "load_balancer_http" {
  network_acl_id = aws_network_acl.load_balancer.id
  rule_number = 100
  egress = false
  protocol = "tcp"
  rule_action = "allow"
  cidr_block = "0.0.0.0/0"
  from_port = 80
  to_port = 80
}

resource "aws_network_acl_rule" "load_balancer_https" {
  network_acl_id = aws_network_acl.load_balancer.id
  rule_number = 200
  egress = false
  protocol = "tcp"
  rule_action = "allow"
  cidr_block = "0.0.0.0/0"
  from_port = 443
  to_port = 443
}

resource "aws_network_acl_rule" "ingress_load_balancer_ephemeral" {
  network_acl_id = aws_network_acl.load_balancer.id
  rule_number = 300
  egress = false
  protocol = "tcp"
  rule_action = "allow"
  cidr_block = "0.0.0.0/0"
  from_port = 1024
  to_port = 65535
}

resource "aws_network_acl_rule" "ecs_task_ephemeral" {
  network_acl_id = aws_network_acl.ecs_task.id
  rule_number = 100
  egress = false
  protocol = "tcp"
  rule_action = "allow"
  cidr_block = "0.0.0.0/0"
  from_port = 1024
  to_port = 65535
}

resource "aws_network_acl_rule" "ecs_task_http" {
  network_acl_id = aws_network_acl.ecs_task.id
  rule_number = 200
  egress = false
  protocol = "tcp"
  rule_action = "allow"
  cidr_block = aws_vpc.test.cidr_block
  from_port = 80
  to_port = 80
}

resource "aws_network_acl_rule" "load_balancer_ephemeral" {
  network_acl_id = aws_network_acl.load_balancer.id
  rule_number = 100
  egress = true
  protocol = "tcp"
  rule_action = "allow"
  from_port = 0
  to_port = 65535
  cidr_block = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "ecs_task_all" {
  network_acl_id = aws_network_acl.ecs_task.id
  rule_number = 100
  egress = true
  protocol = "tcp"
  rule_action = "allow"
  from_port = 0
  to_port = 65535
  cidr_block = "0.0.0.0/0"
}