variable "vpc_id" {
  type = string
}

variable "clb_cidr" {
  type = string
}

variable "clb_az" {
  type = string
}

variable "name" {
  type = string
}

variable "instance_ids" {
  type = list(string)
}

variable "listener_tcp_ports" {
  type = list(number)
}

variable "listener_http_ports" {
  type = list(number)
}