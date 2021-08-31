
output "security_group_id" {
  description = "The ID of the security group"
  value       = alicloud_security_group.emqx.id
}
