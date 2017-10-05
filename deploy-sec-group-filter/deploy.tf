module "deploy_sec_group" {
  source = "../deploy-app"
  name = "${var.suffix == "" ?  format("%s_sec_group", var.name) : format("%s%s", var.name, var.suffix)}"
  space = "${var.sec_group_space}"
  org = "${var.sec_group_org}"
  buildpack = "java_buildpack"
  domains = [
    "${var.sec_group_domain}"]
  memory = "256M"
  path = "https://github.com/orange-cloudfoundry/sec-group-broker-filter/releases/download/v${var.sec_group_filter_version}.RELEASE/service-broker-filter-securitygroups-${var.sec_group_filter_version}.RELEASE.jar"
  env_var = {
    "BROKER_FILTER_URL" = "${var.url}"
    "BROKER_FILTER_USER" = "${var.username}"
    "BROKER_FILTER_PASSWORD" = "${var.password}"
    "BROKER_FILTER_TRUSTED_DESTINATION_HOSTS" = "${join(",", var.trusted_destination_hosts)}"
    "BROKER_FILTER_TRUSTED_DESTINATION_PORTS" = "${join(",", var.trusted_destination_ports)}"
    "CLOUDFOUNDRY_HOST" = "${replace(replace(var.cf_api_endpoint, "https://", ""), "http://", "")}"
    "CLOUDFOUNDRY_USER" = "${var.cf_username}"
    "CLOUDFOUNDRY_PASSWORD" = "${var.cf_password}"
    "BROKER_FILTER_SERVICEOFFERING_SUFFIX" = "${var.suffix}"
    "JAVA_OPTS" = "-Djava.security.egd=file:/dev/urandom"
  }
}

resource "cloudfoundry_service_broker" "service_broker" {
  name = "${var.suffix == "" ?  var.name : format("%s%s", var.name, var.suffix)}"
  url = "${element(module.deploy_sec_group.app_uris, 1)}"
  username = "${var.username}"
  password = "${var.password}"
  space_id = "${var.space_scoped ? module.deploy_sec_group.space_id : ""}"
  service_access = "${var.service_access}"
}