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

# variable "org_id" {
#     default = "604523b27dac95237159238f"
# }

# variable "hosted_zone_id" {
#     default = "Z03784031V2KZIRLBHZDF"
# }