# VPC
output "vpc_id" {
  description = "The ID of the VPC"
  value       = alicloud_vpc.vpc.id
}

output "vswitch_ids" {
  description = "List of IDs of vswitch"
  value       = alicloud_vswitch.vsw.*.id
}