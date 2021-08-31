
variable "namespace" {
  type = string
}

variable "region" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "vswitch_conf" {
  type = list(any)
}