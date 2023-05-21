locals {
  az_count = length(data.alicloud_zones.zones_ds.zones.*.id)
}

data "alicloud_zones" "zones_ds" {
  available_instance_type = var.instance_type
}

# Create a new ECS instance for VPC
resource "alicloud_vpc" "vpc" {
  vpc_name   = "${var.namespace}-vpc"
  cidr_block = var.emqx_address_space
}

resource "alicloud_vswitch" "vsw" {
  count = var.instance_count

  vpc_id       = alicloud_vpc.vpc.id
  cidr_block   = cidrsubnet(var.emqx_address_space, 8, count.index)
  zone_id = element(data.alicloud_zones.zones_ds.zones.*.id,
    count.index % local.az_count)
  # zone_id = "${var.region}-a"
}
