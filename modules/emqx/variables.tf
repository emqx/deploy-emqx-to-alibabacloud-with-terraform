variable "region" {
  type = string
}

variable "instance_name" {
  type = string
}

variable "image_id" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "system_disk_category" {
  type = string
}

variable "system_disk_size" {
  type = number
}

variable "security_group_id" {
  type = string
}

variable "internet_max_bandwidth_out" {
  type = number
}

variable "vswitch_ids" {
  type = list(string)
}

variable "emqx_package" {
  type = string
}

# variable "emqx_lic" {
#   type = string
# }
