provider "azurerm" {
  features {}
}
module "resourcegroup" {
  source         = "./modules/resourcegroup"
  name           = var.name
  location       = var.location
}

module "networking" {
  source         = "./modules/networking"
  location       = module.resourcegroup.location_id
  resource_group = module.resourcegroup.resource_group_name
  vnetcidr       = var.vnetcidr
  websubnetcidr  = var.websubnetcidr
  mgtsubnetcidr  = var.mgtsubnetcidr
  dbsubnetcidr   = var.dbsubnetcidr
  adsubnetcidr   = var.adsubnetcidr
  lbsubnetcidr   = var.lbsubnetcidr
}

module "securitygroup" {
  source         = "./modules/securitygroup"
  location       = module.resourcegroup.location_id
  resource_group = module.resourcegroup.resource_group_name 
  web_subnet_id  = module.networking.websubnet_id
  db_subnet_id   = module.networking.dbsubnet_id
  mgt_subnet_id  = module.networking.mgtsubnet_id
  ad_subnet_id   = module.networking.adsubnet_id
}
module "loadbalancer" {
  source = "./modules/loadbalancer"
  location = module.resourcegroup.location_id
  resource_group = module.resourcegroup.resource_group_name
  network_name = module.networking.network_name
  lb_subnet = module.networking.lbsubnet_id
}
module "compute" {
  source         = "./modules/compute"
  location = module.resourcegroup.location_id
  resource_group = module.resourcegroup.resource_group_name
  web_subnet_id = module.networking.websubnet_id
  host_name = var.host_name
  username = var.username
  os_password = var.os_password
  backend_address_pool_id = module.loadbalancer.backend_address_pool
}

module "database" {
  source = "./modules/database"
  location = module.resourcegroup.location_id
  resource_group = module.resourcegroup.resource_group_name
  primary_database = var.primary_database
  primary_database_version = var.primary_database_version
  primary_database_admin = var.primary_database_admin
  primary_database_password = var.primary_database_password
  secondary_database = var.secondary_database
  secondary_database_version = var.secondary_database_version
  secondary_database_admin = var.secondary_database_admin
  secondary_password = var.secondary_password
}



