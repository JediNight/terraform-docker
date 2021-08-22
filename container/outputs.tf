output "container-name" {
  value = docker_container.nodered_container.name
}
output "ip-address" {
  value       = [for i in docker_container.nodered_container[*]: join(":", [i.ip_address],i.ports[*]["external"])]
  description = "The name of terraform container"
}
