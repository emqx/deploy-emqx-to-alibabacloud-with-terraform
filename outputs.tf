# output "emqx_public_ips" {
#   description = "public ip of ec2 for each project"
#   value = module.ecs.public_ips
# }

output "clb_public_ip" {
  description = "public ip of clb"
  value       = module.clb.clb_public_ip
}