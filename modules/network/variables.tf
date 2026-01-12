variable "name_prefix" {
  type = string
}

variable "location" {
  type = string
}

variable "vnet_address_space" {
  type = list(string)
}

variable "resource_group_name" {
  type = string
}

variable "common_tags" {
  type = map(string)
}

variable "public_subnet_address_space" {
  type = list(string)
}

variable "private_subnet_address_space" {
  type = list(string)
}