data "template_file" "cs_params" {
  template = "${file(format("%s/params.json", path.module))}"
  count = "${length(var.binds)}"

  vars {
    idle_duration = "${lookup(var.binds[count.index], "idle_duration") == "" ? "24H" : lookup(var.binds[count.index], "idle_duration")}"
    auto_enrollment = "${lookup(var.binds[count.index], "auto_enrollment") == "" ? "standard" : lookup(var.binds[count.index], "auto_enrollment")}"
    idle_exclude = "${lookup(var.binds[count.index], "idle_exclude")}"
    secret = "${lookup(var.binds[count.index], "secret")}"
  }
}
data "cloudfoundry_organization" "bound_org" {
  count = "${length(var.binds)}"
  name = "${lookup(var.binds[count.index], "org")}"
}
data "cloudfoundry_space" "bound_space" {
  count = "${length(var.binds)}"
  name = "${lookup(var.binds[count.index], "space")}"
  org_id = "${element(data.cloudfoundry_organization.bound_org.*.id, count.index)}"
}

resource "cloudfoundry_service" "autosleep_service" {
  depends_on = [
    "module.deploy_autosleep"]
  count = "${length(var.binds)}"
  name = "${element(data.cloudfoundry_space.bound_space.*.name, count.index)}-autosleep"
  space_id = "${element(data.cloudfoundry_space.bound_space.*.id, count.index)}"
  plan = "default"
  params = "${element(data.template_file.cs_params.*.rendered, count.index)}"
}