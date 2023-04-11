variable "name" {
  description = "The name of the ECS service"
  type        = string
}

variable "container_name" {
  description = "The name of the container"
  type        = string
  default     = "nginx"
}

variable "container_port" {
  description = "The port on which the container listens"
  type        = number
  default     = 80
}

variable "image" {
  description = "The Docker image to use for the container"
  type        = string
  default     = "nginx:latest"
}

variable "cpu" {
  description = "The amount of CPU units to reserve for the container"
  type        = number
  default     = 256
}

variable "memory" {
  description = "The amount of memory to reserve for the container"
  type        = number
  default     = 512
}

variable "desired_count" {
  description = "The desired number of tasks to run"
  type        = number
  default     = 1
}

variable "subnet_id1" {
  description = "Enter private subnet id"
}

variable "subnet_id2" {
  description = "Enter private subnet id"
}

variable "cluster" {
  description = "Enter the cluster id"
}

variable "vpc_id" {
  description = "Enter the id of VPC"
}

# variable health_check_path {
#   description = "ARN of the ALB target group"
# }