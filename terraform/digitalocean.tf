resource "digitalocean_kubernetes_cluster" "brodin" {
  name    = "brodin"
  region  = "ams3"
  version = "1.29.1-do.0"

  node_pool {
    name       = "brodin-default"
    size       = "s-2vcpu-2gb"
    node_count = 2
  }
}