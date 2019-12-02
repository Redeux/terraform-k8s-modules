output "name" {
  value = k8s_core_v1_service.che_host.metadata.0.name
}

output "service" {
  value = k8s_core_v1_service.che_host
}

output "deployment" {
  value = k8s_apps_v1_deployment.che
}
