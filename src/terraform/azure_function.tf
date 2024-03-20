resource "azurerm_storage_account" "fiap-fastfood" {
  name                     = "fiap-fastfood"
  resource_group_name      = azurerm_resource_group.fiap-fastfood.name
  location                 = azurerm_resource_group.fiap-fastfood.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  depends_on = [azurerm_resource_group.fiap-fastfood-grupo]  
}

resource "azurerm_service_plan" "fiap-fastfood-plan" {
  name                = "fiap-fastfood-plan"
  location            = azurerm_resource_group.fiap-fastfood.location
  resource_group_name = azurerm_resource_group.fiap-fastfood.name
  os_type             = "Linux"
  sku_name            = "Y1"
  
  depends_on = [azurerm_resource_group.fiap-fastfood-grupo]  
}

resource "azurerm_linux_function_app" "fiap-fastfood-function" {
  name                       = "fiap-fastfood-function"
  location                   = azurerm_resource_group.fiap-fastfood-grupo.location
  resource_group_name        = azurerm_resource_group.fiap-fastfood-grupo.name  
  storage_account_name       = azurerm_storage_account.fiap-fastfood-conta.name
  storage_account_access_key = azurerm_storage_account.fiap-fastfood-conta.primary_access_key
  service_plan_id            = azurerm_service_plan.fiap-fastfood-plan.id    
  app_settings = {
    DATASOURCE_PASSWORD = var.db_password
    DATASOURCE_URL = var.db_connection
    DATASOURCE_USERNAME = var.db_username
  }

  site_config {
    application_stack {
      java_version = "17"
    }
  }

  depends_on = [azurerm_resource_group.fiap-fastfood-grupo]  
}