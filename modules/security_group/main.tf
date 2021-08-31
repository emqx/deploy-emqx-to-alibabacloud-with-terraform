// Security Group module for VPC Module
resource "alicloud_security_group" "emqx" {
  name   = "${var.namespace}-sg"
  vpc_id = var.vpc_id
}

resource "alicloud_security_group_rule" "emqx_ingress" {
  count = length(var.ingress_with_cidr_blocks)

  type              = "ingress"
  security_group_id = alicloud_security_group.emqx.id
  ip_protocol       = var.ingress_with_cidr_blocks[count.index].protocol
  port_range        = var.ingress_with_cidr_blocks[count.index].port_range
  cidr_ip           = var.ingress_with_cidr_blocks[count.index].cidr_blocks
  description       = var.ingress_with_cidr_blocks[count.index].description
}

resource "alicloud_security_group_rule" "emqx_egress" {
  count = length(var.egress_with_cidr_blocks)

  type              = "egress"
  security_group_id = alicloud_security_group.emqx.id
  ip_protocol       = var.egress_with_cidr_blocks[count.index].protocol
  port_range        = var.egress_with_cidr_blocks[count.index].port_range
  cidr_ip           = var.egress_with_cidr_blocks[count.index].cidr_blocks
  description       = var.egress_with_cidr_blocks[count.index].description
}