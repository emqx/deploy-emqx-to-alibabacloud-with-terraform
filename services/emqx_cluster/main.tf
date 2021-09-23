module "vpc" {
  source       = "../../modules/vpc/"
  region       = var.region
  namespace    = var.namespace
  vpc_cidr     = var.vpc_cidr
  vswitch_conf = var.ecs_vswitch_conf
}

module "security_group" {
  source                   = "../../modules/security_group/"
  namespace                = var.namespace
  security_group_name      = var.security_group_name
  vpc_id                   = module.vpc.vpc_id
  ingress_with_cidr_blocks = var.ingress_with_cidr_blocks
  egress_with_cidr_blocks  = var.egress_with_cidr_blocks
}

module "emqx_cluster" {
  source = "../../modules/emqx_cluster/"
  region = var.region

  instance_name              = var.namespace
  image_id                   = var.image_id
  instance_type              = var.instance_type
  system_disk_category       = var.system_disk_category
  system_disk_size           = var.system_disk_size
  internet_max_bandwidth_out = var.internet_max_bandwidth_out
  emqx_package          = var.emqx_package
  # emqx_lic                   = var.emqx_lic

  security_group_id = module.security_group.security_group_id
  vswitch_ids       = module.vpc.vswitch_ids
  instance_count    = length(module.vpc.vswitch_ids)
}

module "clb" {
  source = "../../modules/clb/"

  name                = var.namespace
  clb_cidr            = var.clb_cidr
  clb_az              = var.clb_az
  vpc_id              = module.vpc.vpc_id
  instance_ids        = module.emqx_cluster.instance_ids
  listener_http_ports = var.listener_http_ports
  listener_tcp_ports  = var.listener_tcp_ports
}