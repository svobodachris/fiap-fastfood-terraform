resource "azurerm_container_registry" "fiap-fastfood-registry" {
  name                = "fiap-fastfood-registry"
  resource_group_name = azurerm_resource_group.fiap-fastfood-grupo.name
  location            = azurerm_resource_group.fiap-fastfood-grupo.location
  sku                 = "Basic"
  admin_enabled       = false

  depends_on = [azurerm_resource_group.fiap-fastfood-grupo]    
}

resource "azurerm_kubernetes_cluster" "fiap-fastfood-cluster" {
  name                = "fiap-fastfood-cluster"
  location            = azurerm_resource_group.fiap-fastfood-grupo.location
  resource_group_name = azurerm_resource_group.fiap-fastfood-grupo.name
  dns_prefix          = "fiapfastdooscluster"

  default_node_pool {
    name                  = "agentpool"
    type                  = "VirtualMachineScaleSets"
    vm_size               = "Standard_D2_v2"
    os_sku                = "Ubuntu"    
    max_pods              = 30
    enable_node_public_ip = false
    enable_auto_scaling   = true    
    node_count            = 1
    min_count             = 1
    max_count             = 3    
  }

  identity {
    type = "SystemAssigned"
  }
  
  network_profile {
    network_plugin    = "kubenet"
    load_balancer_sku = "standard"
  }

  depends_on = [azurerm_resource_group.fiap-fastfood-grupo]    
}

resource "azurerm_role_assignment" "aks_to_acr" {
  principal_id                     = azurerm_kubernetes_cluster.fiap-fastfood-cluster.kubelet_identity[0].object_id  
  role_definition_name             = "AcrPull"
  scope                            = azurerm_container_registry.fiap-fastfood-registry.id
  skip_service_principal_aad_check = true

  depends_on = [azurerm_resource_group.fiap-fastfood-registry]    
}

resource "azurerm_role_assignment" "aks_to_rg" {
  scope                = azurerm_resource_group.tfiap-fastfood-grupo.id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_kubernetes_cluster.fiap-fastfood-cluster.identity[0].principal_id
  
  depends_on = [azurerm_resource_group.fiap-fastfood-grupo]    
}

