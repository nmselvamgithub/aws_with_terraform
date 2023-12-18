variable "instance_name" {
  description = "Value of the Name tag for the EC2 instance"
  type        = string
  default     = "myappserver"
}

variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "ap-northeast-1"

}