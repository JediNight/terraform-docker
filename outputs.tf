output "container-name" {
  value = module.container[*].container-name
  description = "The name of the container"
}

output "ip-address" {
  value       = flatten(module.container[*].ip-address)
  description = "The name of terraform container"
}
