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

variable "subnets" {
  description = "Subnet definitions keyed by logical name (e.g. private, appgw, etc)"
  type = map(object({
    cidrs = list(string)
    name  = string
    outbound_access_allow = optional(bool, true)
    attach_nat            = optional(bool, false)
  }))
}

variable "enable_nat_gateway" {
    type = bool
    default = true
}

