# output "emqx_public_ips" {
#   description = "public ip of ec2 for each project"
#   value = module.ecs.public_ips
# }

output "emqx_public_ip" {
  description = "public ip of the emqx"
  value       = module.emqx.public_ip
}