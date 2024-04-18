# Create a namespace Traefik
resource "kubernetes_namespace" "traefik" {
  metadata {
    name = "traefik"
  }
}

# Install the helm releas for Traefik
resource "helm_release" "traefik" {
  name       = "traefik"
  repository = "https://helm.traefik.io/traefik"
  chart      = "traefik"
  version    = "27.0.2"
  timeout    = 10000
  # depends_on = [
  #   kubernetes_namespace.traefik
  # ]

  namespace = "traefik"

  # Add values if needed
  values = [
    file("${path.module}/../traefik/values.yaml"),
  ]
}