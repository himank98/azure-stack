resource "azurerm_sql_server" "primary" {
    name = var.primary_database
    resource_group_name = var.resource_group
    location = var.location
    version = var.primary_database_version
    administrator_login = var.primary_database_admin
    administrator_login_password = var.primary_database_password
}

resource "azurerm_sql_server" "secondary" {
    name = var.secondary_database
    resource_group_name = var.resource_group
    location = "West Us"
    version = var.secondary_database_version
    administrator_login = var.secondary_database_admin
    administrator_login_password = var.secondary_password
}

resource "azurerm_sql_database" "db1" {
  name                = "db1"
  resource_group_name = var.resource_group
  location            = var.location
  server_name         = azurerm_sql_server.primary.name
}
resource "azurerm_sql_failover_group" "failoverpolicy" {
  name                = "sql-database-failover123"
  resource_group_name = var.resource_group
  server_name         = azurerm_sql_server.primary.name
  databases           = [azurerm_sql_database.db1.id]
  partner_servers {
    id = azurerm_sql_server.secondary.id
  }

  read_write_endpoint_failover_policy {
    mode          = "Automatic"
    grace_minutes = 60
  }
}
