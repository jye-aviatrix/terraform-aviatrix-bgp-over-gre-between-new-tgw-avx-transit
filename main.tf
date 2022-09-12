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
  local_as_number = var.avx_transit_asn
  bgp_ecmp = true
}

# Create TGW
resource "aws_ec2_transit_gateway" "tgw" {
  description = var.aws_tgw_name
  amazon_side_asn = var.aws_tgw_asn
  tags = {
    "Name" = var.aws_tgw_name
  }
  transit_gateway_cidr_blocks = var.aws_tgw_cidr_blocks
  vpn_ecmp_support = "enable"
}


locals {
  avx_transit_subnet_ids = [for x in module.mc-transit.vpc.subnets: x if length(regexall("Public-gateway-and-firewall-mgmt",x.name))>0][*].subnet_id
}

# Create AWS TGW Attachment to Aviatrix Transit VPC
resource "aws_ec2_transit_gateway_vpc_attachment" "tgw_to_avx_transit_vpc" {
  subnet_ids         = local.avx_transit_subnet_ids
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  vpc_id             = module.mc-transit.vpc.vpc_id
  tags = {
    "Name" = var.avx_transit_gw_ha
  }
}
