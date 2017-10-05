data "cloudfoundry_stack" "default_stack" {
  first = "${var.stack == "" ? "true" : "false"}"
  name = "${var.stack == "" ? "" : var.stack}"
}
data "cloudfoundry_organization" "org_app" {
  name = "${var.org}"
}
data "cloudfoundry_space" "space_app" {
  name = "${var.space}"
  org_id = "${data.cloudfoundry_organization.org_app.id}"
}

data "cloudfoundry_domain" "domains_app" {
  first = "${length(var.domains) == 0 ? "true" : "false"}"
  count = "${length(var.domains) == 0 ? "1" : length(var.domains)}"
  name = "${length(var.domains) > 0 ? element(concat(var.domains, list("")), count.index) : ""}"
}

resource "cloudfoundry_route" "route_app" {
  count = "${length(data.cloudfoundry_domain.domains_app.*.id)}"
  hostname = "${var.host == "" ? var.name : var.host}"
  space_id = "${data.cloudfoundry_space.space_app.id}"
  domain_id = "${element(data.cloudfoundry_domain.domains_app.*.id, count.index)}"
  path = "${var.path_for_route}"
  port = "${var.port_for_route}"
  service_id = "${length(cloudfoundry_service.route_service.*.id) > 0 ? element(concat(cloudfoundry_service.route_service.*.id, list("")), count.index) : ""}"
}
resource "cloudfoundry_app" "app" {
  name = "${var.name}"
  stack_id = "${data.cloudfoundry_stack.default_stack.id}"
  space_id = "${data.cloudfoundry_space.space_app.id}"
  instances = "${var.instances}"
  diego = "${var.diego}"
  started = "${var.started}"
  enable_ssh = "${var.enable_ssh}"
  memory = "${var.memory}"
  routes = [
    "${cloudfoundry_route.route_app.*.id}"]
  path = "${var.path}"
  env_var = "${var.env_var}"
  ports = "${var.ports}"
  services = [
    "${cloudfoundry_service.service_app.*.id}"]
  command = "${var.command}"
  disk_quota = "${var.disk_quota}"
  health_check_http_endpoint = "${var.health_check_http_endpoint}"
  health_check_type = "${var.health_check_type}"
  health_check_timeout = "${var.health_check_timeout}"
  buildpack = "${var.buildpack}"
}
resource "cloudfoundry_service" "service_app" {
  count = "${length(var.services)}"
  name = "${lookup(var.services[count.index], "name")}"
  space_id = "${data.cloudfoundry_space.space_app.id}"
  user_provided = "${lookup(var.services[count.index], "user_provided", "")}"
  params = "${lookup(var.services[count.index], "params", "")}"
  update_params = "${lookup(var.services[count.index], "update_params", "")}"
  tags = "${split(",", lookup(var.services[count.index], "tags", ""))}"
  service = "${lookup(var.services[count.index], "service", "")}"
  plan = "${lookup(var.services[count.index], "plan", "")}"
  route_service_url = "${lookup(var.services[count.index], "route_service_url", "")}"
  syslog_drain_url = "${lookup(var.services[count.index], "syslog_drain_url", "")}"
}
resource "cloudfoundry_service" "route_service" {
  count = "${length(var.route_services)}"
  name = "${lookup(var.route_services[count.index], "name")}"
  space_id = "${data.cloudfoundry_space.space_app.id}"
  user_provided = "${lookup(var.route_services[count.index], "user_provided", "")}"
  params = "${lookup(var.route_services[count.index], "params", "")}"
  update_params = "${lookup(var.route_services[count.index], "update_params", "")}"
  tags = "${split(",", lookup(var.route_services[count.index], "tags", ""))}"
  service = "${lookup(var.route_services[count.index], "service", "")}"
  plan = "${lookup(var.route_services[count.index], "plan", "")}"
  route_service_url = "${lookup(var.route_services[count.index], "route_service_url", "")}"
  syslog_drain_url = "${lookup(var.services[count.index], "syslog_drain_url", "")}"
}
