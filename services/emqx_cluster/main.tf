data "local_file" "package_file" {
  filename = var.emqx_package
}

# throw error when packge not exists
locals {
  file_exists = fileexists(data.local_file.package_file.filename)
}

module "vpc" {
  source       = "../../modules/vpc/"
  region       = var.region
  namespace    = var.namespace
  instance_type = var.instance_type

  emqx_address_space = var.emqx_address_space
  instance_count = var.emqx_instance_count
}

module "security_group" {
  source                   = "../../modules/security_group/"
  namespace                = var.namespace
  security_group_name      = var.security_group_name
  vpc_id                   = module.vpc.vpc_id
  ingress_with_cidr_blocks = var.ingress_with_cidr_blocks
  egress_with_cidr_blocks  = var.egress_with_cidr_blocks
}

module "emqx4_cluster" {
  count = var.is_emqx5 ? 0 : 1

  source = "../../modules/emqx4_cluster/"
  region = var.region

  instance_name              = var.namespace
  instance_count    = var.emqx_instance_count
  image_id                   = var.image_id
  instance_type              = var.instance_type
  system_disk_category       = var.system_disk_category
  system_disk_size           = var.system_disk_size
  internet_max_bandwidth_out = var.internet_max_bandwidth_out
  emqx_package          = var.emqx_package
  emqx_lic                   = var.emqx_lic
  cookie = var.emqx_cookie

  security_group_id = module.security_group.security_group_id
  vswitch_ids = module.vpc.vswitch_ids
}

module "emqx5_cluster" {
  count = var.is_emqx5 ? 1 : 0
  source = "../../modules/emqx5_cluster/"
  region = var.region

  instance_name              = var.namespace
  instance_count    = var.emqx_instance_count
  core_count                  = var.emqx5_core_count
  image_id                   = var.image_id
  instance_type              = var.instance_type
  system_disk_category       = var.system_disk_category
  system_disk_size           = var.system_disk_size
  internet_max_bandwidth_out = var.internet_max_bandwidth_out
  emqx_package          = var.emqx_package
  emqx_lic                   = var.emqx_lic
  cookie = var.emqx_cookie

  security_group_id = module.security_group.security_group_id
  vswitch_ids = module.vpc.vswitch_ids
}

module "clb" {
  source = "../../modules/clb/"

  name                = var.namespace
  region = var.region
  instance_type       = var.instance_type
  clb_cidr = cidrsubnet(var.emqx_address_space, 8, var.emqx_instance_count)
  vpc_id              = module.vpc.vpc_id
  instance_ids          = var.is_emqx5 ? module.emqx5_cluster[0].instance_ids : module.emqx4_cluster[0].instance_ids
  listener_http_ports = var.listener_http_ports
  listener_tcp_ports  = var.listener_tcp_ports
}
