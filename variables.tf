variable "name" {
  description = "Name prefix for the resources of this stack"
}

variable "cidr" {
  description = "Network CIDR to use for clients"
}

variable "subnet_ids" {
  type        = list(string)
  description = "Subnet ID to associate clients"
}

variable "vpc_id" {
  type        = string
  description = "VPC id"
}

variable "organization_name" {
  description = "Name of organization to use in private certificate"
  default     = "ACME, Inc"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Extra tags to attach to resources"
}

variable "logs_retention" {
  default     = 365
  description = "Retention in days for CloudWatch Log Group"
}

variable "split_tunnel" {
  type        = bool
  description = "Indicates whether split-tunnel is enabled on VPN endpoint"
  default     = true
}

variable "auth_target_network_cidr" {
  type        = string
  description = "The IPv4 address range, in CIDR notation, of the network to which the authorization rule applies"
  default     = "0.0.0.0/0"
}

variable "auth_settings" {
  type        = map(any)
  description = "VPN authentication options"
  default     = {}
}
