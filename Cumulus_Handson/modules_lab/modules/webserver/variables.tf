variable "nms_public_subnets" {
  description = "Public-Subnet"
  type        = list(any)
}

variable "nms_vpc_id" {
  description = "VPC_ID"
  type        = string
  validation {
    condition     = length(var.nms_vpc_id) > 4 && substr(var.nms_vpc_id, 0, 4) == "vpc-"
    error_message = "VPC ID must not empty."
  }

}

variable "ingress_rules" {
  type = list(object({
    port        = number
    proto       = string
    cidr_blocks = list(string)
  }))
  default = [{
    port        = 80
    proto       = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    },
    {
      port        = 22
      proto       = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }]
}

