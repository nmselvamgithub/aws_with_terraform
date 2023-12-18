variable "vpc_cidr" {
  description = "CIDR for VPC"
  type        = string
}

variable "vpc_tags" {
  description = "Tags for VPC"
  type        = map(any)
}

variable "availability_zones" {
  description = "AZ's for subnets"
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "CIDR for public subnets"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "CIDR for private subnets"
  type        = list(string)
}