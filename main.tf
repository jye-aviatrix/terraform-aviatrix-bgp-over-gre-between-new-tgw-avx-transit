# Create Aviatrix Transit

module "mc-transit" {
  source  = "terraform-aviatrix-modules/mc-transit/aviatrix"
  version = "2.2.1"
  # insert the 3 required variables here
  cloud = var.cloud
  region = var.region
  cidr = var.cidr
  account = var.account
  ha_gw = var.avx_transit_gw_ha
  gw_name = var.avx_transit_gw_name
}