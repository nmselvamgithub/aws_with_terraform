output "vpc_id" {
  value = module.nmstokyovpc.vpc_id
}

output "load_balancer_dns_name" {
  description = "Loadbalancer DNS name"
  value       = module.webserver.load_balancer_dns_name
}