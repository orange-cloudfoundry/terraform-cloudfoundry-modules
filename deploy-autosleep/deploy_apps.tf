module "deploy_autowakeup" {
  source = "../deploy-app"
  name = "${var.broker_name}-autowakeup-proxy"
  org = "${var.broker_org}"
  space = "${var.broker_space}"
  buildpack = "java_buildpack"
  domains = [
    "${var.broker_domain}"]
  memory = "256M"
  path = "https://github.com/cloudfoundry-community/autosleep/releases/download/v${var.autosleep_version}/org.cloudfoundry.autosleep.autowakeup-proxy-${var.autosleep_version}.war"
  env_var = "${local.env_var}"
  services = "${local.services}"
}
locals {
  env_var = {
    "security_user_name" = "${var.broker_username}"
    "security_user_password" = "${var.broker_password}"
    "cf_client_target_host" = "${var.cf_api_endpoint}"
    "cf_client_username" = "${var.cf_username}"
    "cf_client_password" = "${var.cf_password}"
    "cf_client_clientId" = "${var.cf_client_id}"
    "cf_client_clientSecret" = "${var.cf_client_secret}"
    "cf_security_password_encodingSecret" = ""
    "cf_service_broker_name" = "${var.broker_name}"
    "cf_service_broker_id" = "${var.broker_name}"
    "JAVA_OPTS" = "-Djava.security.egd=file:/dev/urandom -Dlogging.level.org.springframework.web.filter.CommonsRequestLoggingFilter=ERROR"
  }
  services = [
    {
      name = "${var.broker_name}_database"
      service = "${var.service_database_name}"
      plan = "${var.service_database_plan}"
    }]
}
module "deploy_autosleep" {
  source = "../deploy-service-broker"
  name = "${var.broker_name}"
  org = "${var.broker_org}"
  space = "${var.broker_space}"
  broker_username = "${var.broker_username}"
  broker_password = "${var.broker_password}"
  path = "https://github.com/cloudfoundry-community/autosleep/releases/download/v${var.autosleep_version}/org.cloudfoundry.autosleep.autosleep-core-${var.autosleep_version}.war"
  memory = "256M"
  env_var = "${local.env_var}"
  services = "${local.services}"
  service_access = [
    {
      service = "${var.broker_name}"
    }]
}
