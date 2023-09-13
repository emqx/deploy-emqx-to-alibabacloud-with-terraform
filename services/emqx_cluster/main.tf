locals {
  package_url = var.is_emqx5 ? var.emqx5_package : var.emqx4_package
}

#######################################
# check package
#######################################

resource "null_resource" "check_path" {
  triggers = {
    package = local.package_url
  }

  # Execute a local script
  provisioner "local-exec" {
    command = <<EOT
      #!/bin/bash
      set -e

      # Define the URL to check
      url="${local.package_url}"

      # Check if the URL ends with tar.gz or zip
      if [[ "$url" =~ ubuntu20.04-amd64\.(zip|tar\.gz)$ ]]; then
        echo "URL suffix is valid (ubuntu20.04-amd64.tar.gz or ubuntu20.04-amd64.zip)."
      else
        echo "Invalid URL suffix. URL should end with ubuntu20.04-amd64.tar.gz or ubuntu20.04-amd64.zip."
        exit 1
      fi
    EOT
  }
}

module "vpc" {
  source       = "../../modules/vpc/"
  region       = var.region
  namespace    = var.namespace
  instance_type = var.instance_type

  emqx_address_space = var.emqx_address_space
  instance_count = var.emqx_instance_count
  depends_on = [null_resource.check_path]
}

module "security_group" {
  source                   = "../../modules/security_group/"
  namespace                = var.namespace
  security_group_name      = var.security_group_name
  vpc_id                   = module.vpc.vpc_id
  ingress_with_cidr_blocks = var.ingress_with_cidr_blocks
  egress_with_cidr_blocks  = var.egress_with_cidr_blocks
  depends_on = [null_resource.check_path]
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
  emqx_package          = var.emqx4_package
  emqx_lic                   = var.emqx_lic
  cookie = var.emqx_cookie

  security_group_id = module.security_group.security_group_id
  vswitch_ids = module.vpc.vswitch_ids
  depends_on = [null_resource.check_path]
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
  emqx_package          = var.emqx5_package
  emqx_lic                   = var.emqx_lic
  cookie = var.emqx_cookie

  security_group_id = module.security_group.security_group_id
  vswitch_ids = module.vpc.vswitch_ids
  depends_on = [null_resource.check_path]
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
  depends_on = [null_resource.check_path]
}
