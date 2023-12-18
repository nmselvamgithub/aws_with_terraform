output "load_balancer_dns_name" {
  description = "Loadbalancer DNS name"
  value       = aws_lb.nmsLoadBalancer.dns_name
}