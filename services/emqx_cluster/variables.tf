## Common

variable "namespace" {
  type        = string
  default     = "tf-emqx"
  description = "namespace"
}

variable "region" {
  type        = string
  default     = "cn-shenzhen"
  description = "Ali region"
}

variable "access_key" {
  description = "AWS access key"
  type        = string
  default     = null
}

variable "secret_key" {
  description = "AWS secret key"
  type        = string
  default     = null
}

## Vpc

variable "emqx_address_space" {
  type        = string
  default     = ""
  description = "cidr of vpc"
}

variable "clb_cidr" {
  type        = string
  default     = ""
  description = "cidr for the clb"
}

variable "clb_az" {
  type        = string
  default     = ""
  description = "description"
}


## Security Group

variable "security_group_name" {
  type        = string
  default     = "tf-security-group"
  description = "security group name"
}

variable "ingress_with_cidr_blocks" {
  type        = list(any)
  default     = [
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
  description = "(Required) ingress of emqx with cidr blocks"
}

variable "egress_with_cidr_blocks" {
  type        = list(any)
  default     = [
    {
      description = "all"
      port_range  = "-1/-1"
      protocol    = "all"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
  description = "egress with cidr blocks"
}

## Ecs

variable "instance_type" {
  type        = string
  default     = "ecs.t6-c1m1.large"
  description = "instance type"
}

variable "image_id" {
  type        = string
  default     = "ubuntu_20_04_x64_20G_alibase_20210623.vhd"
  description = "image id"
}

variable "system_disk_category" {
  type        = string
  default     = "cloud_efficiency"
  description = "system disk category"
}

variable "system_disk_size" {
  type        = number
  default     = 50
  description = "system disk size"
}

variable "internet_max_bandwidth_out" {
  type        = number
  default     = 10
  description = "internet max bandwidth out"
}

variable "emqx_lic" {
  type        = string
  default     = ""
  description = "emqx license"
}

## clb

variable "listener_tcp_ports" {
  type        = list(number)
  default     = []
  description = "the tcp listener ports of clb"
}

variable "listener_http_ports" {
  type        = list(number)
  default     = []
  description = "the http listener ports of clb"
}

variable "emqx4_package" {
  description = "(Required) The install package of emqx4"
  type        = string
  default     = ""
}

variable "emqx5_package" {
  description = "(Required) The install package of emqx5"
  type        = string
  default     = ""
}

variable "emqx_instance_count" {
  description = "(Required) The count of emqx node"
  type        = number
  default     = 1
}

variable "emqx5_core_count" {
  description = "(Required) The count of emqx core node"
  type        = number
  default     = 1
}

variable "is_emqx5" {
  description = "(Optional) Is emqx5 or not"
  type        = bool
  default     = false
}

variable "emqx_cookie" {
  description = "(Optional) The cookie of emqx"
  type        = string
  default     = "emqx_secret_cookie"
}

