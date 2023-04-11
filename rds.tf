resource "aws_db_subnet_group" "interview_25" {
  name       = "interview_25"
  subnet_ids = [aws_subnet.private.id, aws_subnet.private2.id]
  tags = {
    Name = "My DB subnet group"
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
  password = var.password
  port = var.port
  identifier = var.identifier
  skip_final_snapshot = var.skip_final_snapshot
  publicly_accessible  = false
  multi_az = true
  db_subnet_group_name = aws_db_subnet_group.interview_25.name
}