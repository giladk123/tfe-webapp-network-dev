terraform {
  cloud {
    hostname = "app.terraform.io"
    organization = "hcta-azure-dev"
    
    workspaces {
      name = "tfe-webapp-network-dev"
    }
  }
} 