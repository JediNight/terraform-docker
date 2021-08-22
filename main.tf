module "image" {
  source = "./image"
  image_in = var.image[terraform.workspace]
}

resource "null_resource" "dockervol"{
 provisioner "local-exec" {
     command = "mkdir noderedvol || true && chown -R 1000:1000 noderedvol"
 }
}

resource "random_string" "random" {
  count   = local.container_count
  length  = 4
  special = false
  upper   = false
}
# resource "random_string" "random2" {
#     length = 4
#     special = false
#     upper = false
# }

locals {
  // TODO: Windows only Workaround - not recommended!
  root_path = "/${replace(abspath(path.root), ":", "")}"
}

module "container" {
  source = "./container"
  count = local.container_count
  depends_on= [null_resource.dockervol]
  name_in  = join("-", ["nodered", null_resource.dockervol.id, random_string.random[count.index].result])
  image_in = module.image.image_out
  int_port_in = var.int_port
  ext_port_in = var.ext_port[terraform.workspace][count.index]
  container_path_in = "/data"
  host_path_in = "${local.root_path}/noderedvol"
} 

# output "container-name"{
#     value = docker_container.nodered_container[*].name
#     description = "The name of terraform container"
# }
output "random_string" {
  value = random_string.random[0].result
}




# output "container-name2"{
#     value = docker_container.nodered_container[1].name
#     description = "The name of terraform container"
# }

