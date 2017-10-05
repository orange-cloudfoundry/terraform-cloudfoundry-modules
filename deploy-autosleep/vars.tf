variable "broker_domain" {
  type = "string"
}
variable "broker_org" {
  type = "string"
}
variable "broker_space" {
  type = "string"
}
variable "broker_name" {
  type = "string"
  default = "autosleep"
}
variable "broker_username" {
  type = "string"
}
variable "broker_password" {
  type = "string"
}
variable "autosleep_version" {
  type = "string"
  default = "1.0.0"
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
variable "cf_client_id" {
  type = "string"
}
variable "cf_client_secret" {
  type = "string"
}
variable "service_database_name" {
  type = "string"
  default = "p-mysql"
}
variable "service_database_plan" {
  type = "string"
  default = "10mb"
}
variable "binds" {
  type = "list"
  default = []
}