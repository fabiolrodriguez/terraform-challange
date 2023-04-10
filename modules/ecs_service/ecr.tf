resource "aws_ecr_repository" "xpass-repo" {
  name                 = "xpass-${var.name}"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}