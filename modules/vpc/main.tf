# Create a new ECS instance for VPC
resource "alicloud_vpc" "vpc" {
  vpc_name   = "${var.namespace}-vpc"
  cidr_block = var.vpc_cidr
}

resource "alicloud_vswitch" "vsw" {
  count = length(var.vswitch_conf)

  vpc_id       = alicloud_vpc.vpc.id
  cidr_block   = var.vswitch_conf[count.index].cidr
  zone_id      = var.vswitch_conf[count.index].az
  vswitch_name = var.vswitch_conf[count.index].name
}
