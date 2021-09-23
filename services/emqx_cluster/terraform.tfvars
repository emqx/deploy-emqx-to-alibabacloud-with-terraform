## common

namespace = "tf-emqx-cluster"

## vpc

# vpc_cidr = "10.65.0.0/16"
vpc_cidr = "172.16.0.0/16"

ecs_vswitch_conf = [
  {
    "name" = "tf-vswitch-01",
    "az"   = "cn-shenzhen-d",
    "cidr" = "172.16.1.0/24"
    # "cidr" = "10.65.128.0/18"
  },
  {
    "name" = "tf-vswitch-02",
    "az"   = "cn-shenzhen-e",
    "cidr" = "172.16.2.0/24"
    # "cidr" = "10.65.192.0/18"
  }
]

clb_cidr = "172.16.3.0/24"
clb_az   = "cn-shenzhen-d"

## security group

ingress_with_cidr_blocks = [
  {
    description = "ssh"
    port_range  = "22/22"
    protocol    = "tcp"
    cidr_blocks = "0.0.0.0/0"
  },
  {
    description = "mqtt"
    port_range  = "1883/1883"
    protocol    = "tcp"
    cidr_blocks = "0.0.0.0/0"
  },
  {
    description = "mqtts"
    port_range  = "8883/8883"
    protocol    = "tcp"
    cidr_blocks = "0.0.0.0/0"
  },
  {
    description = "ws"
    port_range  = "8083/8083"
    protocol    = "tcp"
    cidr_blocks = "0.0.0.0/0"
  },
  {
    description = "wss"
    port_range  = "8084/8084"
    protocol    = "tcp"
    cidr_blocks = "0.0.0.0/0"
  },
  {
    description = "dashboard"
    port_range  = "18083/18083"
    protocol    = "tcp"
    cidr_blocks = "0.0.0.0/0"
  },
  {
    description = "cluster ekka"
    port_range  = "4370/4370"
    protocol    = "tcp"
    cidr_blocks = "0.0.0.0/0"
  },
  {
    description = "cluster rpc"
    port_range  = "5370/5370"
    protocol    = "tcp"
    cidr_blocks = "0.0.0.0/0"
  }
]

egress_with_cidr_blocks = [
  {
    description = "all"
    port_range  = "-1/-1"
    protocol    = "all"
    cidr_blocks = "0.0.0.0/0"
  }
]

## clb

listener_tcp_ports = [
  1883, 8883, 8083, 8084
]

listener_http_ports = [
  18083
]


emqx_package = "https://www.emqx.com/zh/downloads/broker/4.3.8/emqx-ubuntu20.04-4.3.8-amd64.zip"