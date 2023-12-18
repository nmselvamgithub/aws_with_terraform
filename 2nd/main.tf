terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = var.aws_region
}

resource "aws_instance" "myappserver" {
  ami           = "ami-0dafcef159a1fc745"
  instance_type = "t2.micro"

  tags = {
    Name = var.instance_name
  }
}
