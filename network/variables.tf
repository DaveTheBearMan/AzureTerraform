// Network Variables
variable "ip_accept_range" {
  type      = string
  default   = "129.21.0.0/16" // RIT IP Address
}

variable "internal_ip_range" {
  type      = string
  default   = "10.0.2.0/24"
}

variable "accept_all_range" {
  type      = string
  default   = "0.0.0.0/0"
}

variable "resource_group_name" {
  type    = string
}

variable "resource_group_location" {
  type    = string
}