## common

namespace = "tf-emqx-single"

## vpc

# vpc_cidr = "10.65.0.0/16"
vpc_cidr = "172.16.0.0/16"

ecs_vswitch_conf = [
  {
    "name" = "tf-vswitch-01",
    "az"   = "cn-shenzhen-d",
    "cidr" = "172.16.11.0/24"
  }
]

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

emqx_package = "https://www.emqx.com/zh/downloads/broker/4.3.8/emqx-ubuntu20.04-4.3.8-amd64.zip"

