locals {
  emqx_home = "/opt/emqx"
}

## ssh certificate
resource "tls_private_key" "key" {
  algorithm = "RSA"
}

resource "local_sensitive_file" "private_key" {
  filename          = "${path.module}/tf-emqx-key.pem"
  content = tls_private_key.key.private_key_pem
  file_permission   = "0400"
}

resource "alicloud_ecs_key_pair" "key_pair" {
  key_pair_name = "tf-emqx-single-key"
  public_key    = tls_private_key.key.public_key_openssh
}


## ecs
resource "alicloud_instance" "ecs" {
  instance_name        = "${var.instance_name}-instance"
  image_id             = var.image_id
  instance_type        = var.instance_type
  system_disk_category = var.system_disk_category
  system_disk_size     = var.system_disk_size
  security_groups      = [var.security_group_id]
  vswitch_id           = var.vswitch_ids[0]

  internet_max_bandwidth_out = var.internet_max_bandwidth_out
  key_name                   = alicloud_ecs_key_pair.key_pair.key_name

  connection {
    type        = "ssh"
    user        = "root"
    host        = self.public_ip
    private_key = tls_private_key.key.private_key_pem
  }

  provisioner "file" {
    content     = templatefile("${path.module}/scripts/init.sh", { local_ip = self.private_ip })
    destination = "/tmp/init.sh"
  }

  # download emqx
  provisioner "remote-exec" {
    inline = [
      "curl -L --max-redirs -1 -o /tmp/emqx.zip ${var.emqx_package}"
    ]
  }

  # init system
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/init.sh",
      "/tmp/init.sh",
    ]
  }

  # Note: validate the above variables, you have to start emqx separately
  provisioner "remote-exec" {
    inline = [
      "sudo ${local.emqx_home}/bin/emqx start"
    ]
  }
}