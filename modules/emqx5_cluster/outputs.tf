// Output the IDs of the ECS instances created
output "instance_ids" {
  description = "The instance id."
  value       = alicloud_instance.ecs[*].id
}

output "public_ips" {
  description = "The public ip of the instance."
  value       = alicloud_instance.ecs[*].public_ip
}

output "private_ips" {
  description = "The private ip of the instance."
  value       = alicloud_instance.ecs[*].private_ip
}