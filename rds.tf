resource "aws_db_subnet_group" "interview_25" {
  name       = "interview_25"
  subnet_ids = [aws_subnet.private.id, aws_subnet.private2.id]
  tags = {
    Name = "DB Subnet group for Interview 25"
  }
}

resource "aws_db_instance" "mysql" {
  allocated_storage = var.allocated_storage
  storage_type = var.storage_type_db
  engine = var.engine
  engine_version = var.engine_version
  instance_class = var.instance_class
  db_name = var.name
  username = var.username
  port = var.port
  identifier = var.identifier
  skip_final_snapshot = var.skip_final_snapshot
  publicly_accessible  = false
  multi_az = true
  db_subnet_group_name = aws_db_subnet_group.interview_25.name
  manage_master_user_password = true
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  tags = {
    Name = "DB MultiAZ for interview_25 ALB"
  }  
}

resource "aws_security_group" "rds_sg" {
  name_prefix = "rds_sg"
  description = "Security group for RDS"
  vpc_id      = aws_vpc.test.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    # Allow incoming connections from another security group
    security_groups = [module.service.security_group]
  }
  tags = {
    Name = "DB SG for interview_25 ALB"
  }
}