# output "emqx_public_ips" {
#   description = "public ip of ec2 for each project"
#   value = module.ecs.public_ips
# }

output "emqx_cluster_address" {
  description = "public ip of clb"
  value       = module.clb.clb_public_ip
}