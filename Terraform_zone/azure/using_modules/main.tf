module "vnet" {
  source       = "../modules/vnet"
  network_name = "ntier"
  network_cidr = ["10.0.0.0/16"]
  location     = "eastus"
  subnet_names = ["web1", "web2"]
  subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
}