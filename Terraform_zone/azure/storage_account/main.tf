resource "azurerm_resource_group" "terraform" {
  name     = "terraform"
  location = "centralindia"
}

resource "azurerm_storage_account" "tfstore" {
  name                     = "tfstore"
  resource_group_name      = "terraform"
  location                 = "Central India"
  account_tier             = "Standard"
  account_replication_type = "GRS"
  tags = {
    environment = "staging"
  }
}