output "vpc_id" {
  value = aws_vpc.nmstokyovpc.id

}

output "nms_public_subnets" {

  description = "Will be used by web server"
  value = [
    aws_subnet.nmsPublicsubnet1,
    aws_subnet.nmsPublicsubnet2
  ]
}

output "nms_private_subnets" {

  description = "Will be used by web server"
  value = [
    aws_subnet.nmsPrivatesubnet1,
    aws_subnet.nmsPrivatesubnet2
  ]
}