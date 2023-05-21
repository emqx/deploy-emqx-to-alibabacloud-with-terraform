locals {
  home       = "/root"
  replicant_count  = var.instance_count - var.core_count
  public_ips =  alicloud_instance.ecs[*].public_ip
  private_ips =  alicloud_instance.ecs[*].private_ip
  private_ips_json = jsonencode([for ip in local.private_ips : format("emqx@%s", ip)])

  public_core_ips       = slice(local.public_ips, 0, var.core_count)
  private_core_ips      = slice(local.private_ips, 0, var.core_count)
  private_core_ips_json = jsonencode([for ip in local.private_core_ips : format("emqx@%s", ip)])

  public_replicant_ips  = slice(local.public_ips, var.core_count, var.instance_count)
  private_replicant_ips = slice(local.private_ips, var.core_count, var.instance_count)
}

## ssl certificate
resource "tls_private_key" "key" {
  algorithm = "RSA"
}

resource "local_sensitive_file" "private_key" {
  filename          = "${path.module}/tf-emqx-key.pem"
  content = tls_private_key.key.private_key_pem
  file_permission   = "0400"
}

resource "alicloud_ecs_key_pair" "key_pair" {
  key_pair_name = "tf-emqx-cluster-key"
  public_key    = tls_private_key.key.public_key_openssh
}


## ecs
resource "alicloud_instance" "ecs" {
  count                = var.instance_count

  instance_name        = "${var.instance_name}-instance"
  image_id             = var.image_id
  instance_type        = var.instance_type
  system_disk_category = var.system_disk_category
  system_disk_size     = var.system_disk_size
  security_groups      = [var.security_group_id]
  vswitch_id           = var.vswitch_ids[count.index]

  internet_max_bandwidth_out = var.internet_max_bandwidth_out
  key_name                   = alicloud_ecs_key_pair.key_pair.key_name
}

resource "null_resource" "emqx_core" {
  depends_on = [alicloud_instance.ecs]

  count = var.core_count

  connection {
    type        = "ssh"
    user        = "root"
    host        = local.public_core_ips[count.index]
    private_key = tls_private_key.key.private_key_pem
  }

  provisioner "file" {
    content     = templatefile("${path.module}/scripts/init-core.sh", { local_ip = local.private_core_ips[count.index], emqx_lic = var.emqx_lic,
      cookie = var.cookie, core_nodes = local.private_core_ips_json, all_nodes = local.private_ips_json })
    destination = "/tmp/init.sh"
  }

  # copy emqx package
  provisioner "file" {
    source      = var.emqx_package
    destination = "/tmp/emqx.tar.gz"
  }

  # init system
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/init.sh",
      "/tmp/init.sh",
      "sudo mv /tmp/emqx ${local.home}",
    ]
  }

  # Note: validate the above variables, you have to start emqx separately
  provisioner "remote-exec" {
    inline = [
      "sudo ${local.home}/emqx/bin/emqx start"
    ]
  }
}

resource "null_resource" "emqx_replicant" {
  depends_on = [null_resource.emqx_core]

  count = local.replicant_count
  connection {
    type        = "ssh"
    user        = "root"
    host        = local.public_replicant_ips[count.index]
    private_key = tls_private_key.key.private_key_pem
  }

  provisioner "file" {
    content     = templatefile("${path.module}/scripts/init-replicant.sh", { local_ip = local.private_replicant_ips[count.index], emqx_lic = var.emqx_lic,
      cookie = var.cookie, core_nodes = local.private_core_ips_json, all_nodes = local.private_ips_json })
    destination = "/tmp/init.sh"
  }

  # copy emqx package
  provisioner "file" {
    source      = var.emqx_package
    destination = "/tmp/emqx.tar.gz"
  }

  # init system
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/init.sh",
      "/tmp/init.sh",
      "sudo mv /tmp/emqx ${local.home}",
    ]
  }

  # Note: validate the above variables, you have to start emqx separately
  provisioner "remote-exec" {
    inline = [
      "sudo ${local.home}/emqx/bin/emqx start"
    ]
  }
}
