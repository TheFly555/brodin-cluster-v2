
### Define variables ###

# Digital Ocean Token
variable "do_token" {}

# Civo token
# variable "civo_token" {}

# Kube Config
variable "kube_config" {
  type    = string
  default = "~/.kube/config"
}

### Providers ###

# Digital Ocean Provider
terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

# Configure the DigitalOcean Provider
provider "digitalocean" {
  token = var.do_token
}


# Civo Provider
# terraform {
#   required_providers {
#     civo = {
#       source = "civo/civo"
#     }
#   }
# }

# # Configure the Civo Provider
# provider "civo" {
#   token = var.civo_token
#   region = "LON1"
# }

# Helm Provider
provider "helm" {
  kubernetes {
    config_path = var.kube_config
  }
  
}

# Kubernetes Provider
provider "kubernetes" {
  config_path = var.kube_config
}