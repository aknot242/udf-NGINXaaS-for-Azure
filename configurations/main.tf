# terraform {
#   required_version = "~> 1.3"
#   required_providers {
#     azurerm = {
#       source  = "hashicorp/azurerm"
#       version = "~> 3.85"
#     }
#   }
# }

# provider "azurerm" {
#   features {}
#   skip_provider_registration = true
# }

# module "prerequisites" {
#   source   = "../prerequisites"
#   location = var.location
#   name     = var.name
#   tags     = var.tags
# }

# module "deployments" {
#   source  = "../deployments/create-or-update"
#   name    = var.name
#   tags    = var.tags
#   sku     = var.sku
#   resource_group_name = var.resource_group_name
# }

# resource "azurerm_nginx_deployment" "example" {
#   name                     = var.name
#   resource_group_name      = module.prerequisites.resource_group_name
#   sku                      = var.sku
#   location                 = var.location
#   diagnose_support_enabled = false

#   identity {
#     type         = "UserAssigned"
#     identity_ids = [module.prerequisites.managed_identity_id]
#   }

#   frontend_public {
#     ip_address = [module.prerequisites.public_ip_address_id]
#   }
#   network_interface {
#     subnet_id = module.prerequisites.subnet_id
#   }

#   tags = var.tags
# }

resource "azurerm_nginx_configuration" "example" {
  count = var.configure ? 1 : 0
  nginx_deployment_id = var.deployment_id
  root_file           = "/etc/nginx/nginx.conf"

  dynamic "config_file" {
    for_each = var.config_files

    content {
      content      = config_file.value["content"]
      virtual_path = config_file.value["virtual_path"]
    }
  }

  # config_file {
  #   content      = filebase64("${path.module}/api.conf")
  #   virtual_path = "/etc/nginx/site/api.conf"
  # }
}