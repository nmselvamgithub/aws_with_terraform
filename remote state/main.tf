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
  region = "ap-northeast-1"
}

resource "aws_instance" "myappserver" {
  ami           = "ami-0a3299a47e8a9111b"
  instance_type = "t2.micro"

  tags = {
    Name = "my_test_server"
  }
}
