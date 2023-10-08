terraform {
  required_providers {
    terratowns = {
      source  = "local.providers/local/terratowns"
      version = "1.0.0"
    }
  }
  cloud {
    organization = "estebanmorenoit"

    workspaces {
      name = "terra-house-1"
    }
  }
}

provider "terratowns" {
  endpoint  = var.terratowns_endpoint
  user_uuid = var.teacherseat_user_uuid
  token     = var.terratowns_access_token
}

module "terrahome_hosting" {
  source          = "./modules/terrahome_aws"
  user_uuid       = var.teacherseat_user_uuid
  public_path     = var.terrahome.public_path
  content_version = var.terrahome.content_version
}

resource "terratowns_home" "home" {
  name            = "Tiramisu Recipe"
  description     = <<DESCRIPTION
Indulge in the classic Italian Tiramisu recipe – a delightful dessert made with layers of coffee-soaked ladyfingers and a creamy mascarpone cheese mixture. This rich and flavorful treat is topped with cocoa powder and optional chocolate shavings, perfect for satisfying your sweet cravings.
DESCRIPTION
  domain_name     = module.terrahome_hosting.domain_name
  town            = "cooker-cove"
  content_version = var.terrahome.content_version
}