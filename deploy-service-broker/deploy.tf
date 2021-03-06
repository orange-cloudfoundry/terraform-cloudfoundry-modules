module "deploy_app" {
  source = "../deploy-app"
  name = "${var.name}"
  space = "${var.space}"
  org = "${var.org}"
  buildpack = "${var.buildpack}"
  command = "${var.command}"
  disk_quota = "${var.disk_quota}"
  domains = "${var.domains}"
  health_check_http_endpoint = "${var.health_check_http_endpoint}"
  health_check_type = "${var.health_check_type}"
  health_check_timeout = "${var.health_check_timeout}"
  host = "${var.host}"
  instances = "${var.instances}"
  memory = "${var.memory}"
  path = "${var.path}"
  diego = "${var.diego}"
  started = "${var.started}"
  enable_ssh = "${var.enable_ssh}"
  stack = "${var.stack}"
  env_var = "${var.env_var}"
  ports = "${var.ports}"
  services = "${var.services}"
  route_services = "${var.route_services}"
  path_for_route = "${var.path_for_route}"
  port_for_route = "${var.port_for_route}"
}

resource "cloudfoundry_service_broker" "service_broker" {
  name = "${var.broker_name == "" ? var.name : var.broker_name}"
  url = "${element(module.deploy_app.app_uris, 1)}"
  username = "${var.broker_username}"
  password = "${var.broker_password}"
  space_id = "${var.space_scoped ? module.deploy_app.space_id : ""}"
  service_access = "${var.service_access}"
}