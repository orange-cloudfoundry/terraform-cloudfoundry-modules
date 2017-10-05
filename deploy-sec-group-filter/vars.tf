variable "sec_group_space" {
  type = "string"
}
variable "sec_group_filter_version" {
  type = "string"
  default = "2.2.1"
}
variable "sec_group_org" {
  type = "string"
}
variable "sec_group_domain" {
  type = "string"
}
variable "name" {
  type = "string"
}
variable "url" {
  type = "string"
}
variable "trusted_destination_hosts" {
  type = "list"
  default = []
}
variable "cf_api_endpoint" {
  type = "string"
}
variable "cf_username" {
  type = "string"
}
variable "cf_password" {
  type = "string"
}
variable "trusted_destination_ports" {
  type = "list"
  default = []
}
variable "username" {
  type = "string"
  default = ""
}
variable "password" {
  type = "string"
  default = ""
}
variable "space_scoped" {
  default = false
}
variable "service_access" {
  type = "list"
  default = []
}
variable "suffix" {
  type = "string"
  default = ""
}