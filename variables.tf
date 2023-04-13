// define VPC
variable "vpc_name" {
    type = string
    default = "test"
}

variable "cidr" {
    type = string
    default = "10.1.0.0/16"
}

variable "private_subnet" {
    type = string
    default = "10.1.1.0/24"
}

variable "private_subnet2" {
    type = string
    default = "10.1.2.0/24"
}

variable "public_subnet" {
    type = string
    default = "10.1.100.0/24"
}

variable "public_subnet2" {
    type = string
    default = "10.1.200.0/24"
}

# RDS

variable "engine" {
  description = "The database engine"
  type = string
  default = "mysql"
  validation {
    error_message = "Please use a valid database engine"
    condition = can(regex(join("", concat(["^("], [join("|", [ 
        "mysql", "postgres"
    ])], [")$"])), var.engine))
  }    
}

variable "identifier" {
  description = "The name of the RDS instance"
  default = "database-interview-25"
  type = string
}

variable "name" {
  description = "The database name"
  default = "interview_25"
  type = string
}

variable "allocated_storage" {
  description = "The amount of allocated storage."
  type = number
  default = 20
}

variable "storage_type_db" {
  description = "type of the storage"
  type = string
  default = "gp3"
  validation {
    error_message = "Please use a valid storage type."
    condition = can(regex(join("", concat(["^("], [join("|", [ 
        "gp2", "gp3"
    ])], [")$"])), var.storage_type_db))
  }
}

variable "username" {
  description = "Username for the master DB user."
  default = "root"
  type = string
}

variable "instance_class" {
  description = "The RDS instance class"
  default = "db.t3.micro"
  type = string
  validation {
    error_message = "Please use a valid instance type."
    condition = can(regex(join("", concat(["^("], [join("|", [ 
        "db.t3.micro", "db.t3.small"
    ])], [")$"])), var.instance_class))
  }  
}

variable "engine_version" {
  description = "The engine version"
  default = "8.0.32"
  type = string
}

variable "skip_final_snapshot" {
  description = "skip snapshot"
  default = "true"
  type = string
}

variable "port" {
  description = "The port on which the DB accepts connections"
  default = 3306
  type = number
  validation {
    error_message = "Please use a valid port."
    condition = can(regex(join("", concat(["^("], [join("|", [ 
        3306, 5432
    ])], [")$"])), var.port))
  }
}