# Create a namespace cert-manager
resource "kubernetes_namespace" "cert-manager" {
  metadata {
    name = "cert-manager"
  }
}

# get CRD's
# resource "null_resource" "cert-manager-crds" {
#   provisioner "local-exec" {
#     command = "kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.9.1/cert-manager.crds.yaml"
#   }
# }


data "http" "crd" {
  url = "https://github.com/cert-manager/cert-manager/releases/download/v1.9.1/cert-manager.crds.yaml"
  request_headers = {
    Accept = "text/plain"
  }
}

locals {
  yamls = [for data in split("---", data.http.crd): yamldecode(data)]
}

resource "kubernetes_manifest" "install-crd" {
  count = length(local.yamls)
  manifest = local.yamls[count.index]
}

# resource "kubernetes_manifest" "install-crd" {
#   count = length(local.yamls)
#   manifest = local.yamls[count.index]
# }

# Create cert-manager using helm 
resource "helm_release" "cert-manager" {
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  version    = "v1.14.4" # Update to the latest version as needed

  namespace = "cert-manager"

  depends_on = [
    kubernetes_manifest.install-crd
  ]

  values = [
    file("${path.module}/cert-manager/values.yaml"),
  ]
}

# Create Lets Encrypt issuer
resource "kubernetes_manifest" "lets-encrypt-issuer" {
  manifest = file("../manifests/cert-manager/lets-encrypt-issuer.yaml")
  depends_on = [
    helm_release.cert-manager,
    kubernetes_manifest.install-crd
  ]
}