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
  depends_on = [
    kubernetes_namespace.traefik
  ]

  namespace = "traefik"

  # Add values if needed
  values = [
    file("${path.module}/traefik/values.yaml"),
  ]
}

# Install middleware for traefik
resource "kubernetes_manifest" "traefik-middleware" {
  manifest = file("${path.module}/../manifests/traefik/traefik-middleware.yaml")
  depends_on = [
    helm_release.traefik
  ]
}

# Install dashboard for traefik
resource "kubernetes_manifest" "traefik-ingress-dashboard" {
  manifest = file("${path.module}/../manifests/traefik/traefik-ingress.yaml")

  depends_on = [
    kubernetes_manifest.traefik-middleware
  ]
}