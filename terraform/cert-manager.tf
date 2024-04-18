# Create a namespace cert-manager
resource "kubernetes_namespace" "cert-manager" {
  metadata {
    name = "cert-manager"
  }
}

resource "helm_release" "cert-manager" {
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  version    = "v1.14.4" # Update to the latest version as needed

  namespace = "cert-manager"

  # depends_on = [
  #   kubernetes_namespace.cert-manager
  # ]

  set {
    name  = "installCRDs"
    value = "true"
  }
}