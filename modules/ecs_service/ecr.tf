resource "aws_ecr_repository" "test-repo" {
  name                 = "test-${var.name}"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}