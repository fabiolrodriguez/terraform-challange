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
  validation {
    error_message = "Please use a valid port. Allowed values is 80, 443 and 8080"
    condition = can(regex(join("", concat(["^("], [join("|", [ 
        80, 443, 8080
    ])], [")$"])), var.container_port))
  }
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
  validation {
    error_message = "Please use a valid value."
    condition = can(regex(join("", concat(["^("], [join("|", [ 
        128, 256, 512, 1024
    ])], [")$"])), var.cpu))
  }
}

variable "memory" {
  description = "The amount of memory to reserve for the container"
  type        = number
  default     = 512
  validation {
    error_message = "Please use a valid value."
    condition = can(regex(join("", concat(["^("], [join("|", [ 
        128, 256, 512, 1024, 2048
    ])], [")$"])), var.memory))
  }
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

variable health_check_path {
  description = "ARN of the ALB target group"
}