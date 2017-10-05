output "app_uris" {
  depends_on = [
    "cloudfoundry_app.app"]
  value = [
    "${cloudfoundry_route.route_app.*.uri}"]
}
output "space_id" {
  value = "${data.cloudfoundry_space.space_app.id}"
}
output "service_ids" {
  depends_on = [
    "cloudfoundry_service.service_app"]
  value = [
    "${cloudfoundry_service.service_app.*.id}"]
}