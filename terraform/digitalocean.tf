# Generate a cluster
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

# update kubeconfig and add the new cluster
resource "null_resource" "add_kube_config" {
  depends_on = [digitalocean_kubernetes_cluster.brodin]

  provisioner "local-exec" {
    command = <<EOF
      doctl kubernetes cluster kubeconfig save ${digitalocean_kubernetes_cluster.brodin.name}
    EOF
  }
}