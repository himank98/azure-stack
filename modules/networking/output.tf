output "network_name" {
  value = azurerm_virtual_network.vnet01.name
}

output "websubnet_id" {
  value = azurerm_subnet.web-subnet.id
}

output "dbsubnet_id" {
  value = azurerm_subnet.db-subnet.id
}

output "mgtsubnet_id" {
  value = azurerm_subnet.mgt-subnet.id
}

output "adsubnet_id" {
  value = azurerm_subnet.ad-subnet.id
}

output "lbsubnet_id" {
  value = azurerm_subnet.lb-subnet.id
}