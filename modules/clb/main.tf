data "alicloud_zones" "zones_ds" {
  available_instance_type = var.instance_type
}

resource "alicloud_vswitch" "clb" {
  vpc_id       = var.vpc_id
  cidr_block   = var.clb_cidr
  vswitch_name = "${var.name}-clb-vsw"
  zone_id      = data.alicloud_zones.zones_ds.zones[0].id
  # zone_id = "${var.region}-a"
}

resource "alicloud_slb_load_balancer" "clb" {
  load_balancer_name = "${var.name}-clb-lb"
  address_type       = "internet"
  load_balancer_spec = "slb.s2.small"
  vswitch_id         = alicloud_vswitch.clb.id
  delete_protection  = "off"
}

resource "alicloud_slb_backend_server" "clb" {
  load_balancer_id = alicloud_slb_load_balancer.clb.id

  dynamic "backend_servers" {
    for_each = var.instance_ids

    content {
      server_id = backend_servers.value
      weight    = 100
    }
  }
}

resource "alicloud_slb_listener" "tcp_listener" {
  count                 = length(var.listener_tcp_ports)
  load_balancer_id      = alicloud_slb_load_balancer.clb.id
  backend_port          = var.listener_tcp_ports[count.index]
  frontend_port         = var.listener_tcp_ports[count.index]
  protocol              = "tcp"
  bandwidth             = -1
  health_check          = "on"
  healthy_threshold     = 8
  unhealthy_threshold   = 8
  health_check_timeout  = 8
  health_check_interval = 5
}

resource "alicloud_slb_listener" "http_listener" {
  count                  = length(var.listener_http_ports)
  load_balancer_id       = alicloud_slb_load_balancer.clb.id
  backend_port           = var.listener_http_ports[count.index]
  frontend_port          = var.listener_http_ports[count.index]
  protocol               = "http"
  bandwidth              = -1
  health_check           = "on"
  healthy_threshold      = 8
  unhealthy_threshold    = 8
  health_check_timeout   = 8
  health_check_interval  = 5
  health_check_http_code = "http_2xx,http_3xx"
}
