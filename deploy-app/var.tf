variable "name" {
  type = "string"
}
variable "space" {
  type = "string"
}
variable "org" {
  type = "string"
}
variable "buildpack" {
  type = "string"
  default = ""
}
variable "command" {
  type = "string"
  default = ""
}
variable "disk_quota" {
  type = "string"
  default = ""
}
variable "health_check_http_endpoint" {
  type = "string"
  default = ""
}
variable "health_check_type" {
  type = "string"
  default = ""
}
variable "health_check_timeout" {
  type = "string"
  default = 0
}
variable "host" {
  type = "string"
  default = ""
}
variable "instances" {
  default = 1
}
variable "memory" {
  type = "string"
  default = "512M"
}
variable "path" {
  type = "string"
}
variable "diego" {
  default = true
}
variable "started" {
  default = true
}
variable "enable_ssh" {
  default = false
}
variable "stack" {
  type = "string"
  default = ""
}
variable "env_var" {
  type = "map"
  default = {}
}
variable "ports" {
  type = "list"
  default = []
}
variable "services" {
  type = "list"
  default = []
}
variable "route_services" {
  type = "list"
  default = []
}
variable "path_for_route" {
  type = "string"
  default = ""
}
variable "port_for_route" {
  default = -1
}
output "app_uris" {
  depends_on = [
    "cloudfoundry_app.app"]
  value = [
    "${cloudfoundry_route.route_app.*.uri}"]
}
output "space_id" {
  value = "${data.cloudfoundry_space.space_app.id}"
}
variable "domains" {
  type = "list"
  default = []
}