variable "environment" {
  type        = string
}

variable "location" {
  type = string
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