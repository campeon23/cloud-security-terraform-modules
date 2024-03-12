output "instance_template_values" {
#   value = [for key in google_compute_instance_template.ecctemplate : key]
    value = google_compute_instance_template.ecctemplate
}

output "instance_template_keys" {
  value = [for key in google_compute_instance_template.ecctemplate : key]
}

output "instance_group_manager_keys" {
  value = keys(google_compute_instance_group_manager.eccmg)
}