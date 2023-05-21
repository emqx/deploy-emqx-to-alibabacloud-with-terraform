## common

namespace = "tf-emqx-cluster"

## region

region = "cn-shenzhen"

## ecs

instance_type = "ecs.n4.small"
emqx_instance_count = 3

## vpc

emqx_address_space = "10.0.0.0/16"

## clb

listener_tcp_ports = [
  1883, 8883, 8083, 8084
]

listener_http_ports = [
  18083
]

## Cookie for emqx

emqx_cookie = "emqx_secret_cookie"

emqx_package = "/Users/bxb/Downloads/emqx-ee-4.4.16-otp24.3.4.2-1-ubuntu20.04-amd64.zip"

## special to emqx 5
# is_emqx5         = true
# emqx_package    = "/Users/bxb/Downloads/emqx-5.0.24-ubuntu20.04-amd64.tar.gz"
# emqx5_core_count = 1
