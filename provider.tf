provider "aws" {
  region  = "us-east-2"
}

terraform {
  backend "s3" {
    bucket = "terraform-state-interview-25"
    key    = "terraform-state.tfstate"
    region = "us-east-2"
  }
}