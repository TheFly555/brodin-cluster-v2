# # Query xsmall instance size
# data "civo_size" "small" {
#     filter {
#         key = "type"
#         values = ["kubernetes"]
#     }

#     sort {
#         key = "ram"
#         direction = "asc"
#     }
# }

# # Create a firewall
# resource "civo_firewall" "brodin-firewall" {
#     name = "brodin-firewall"
# }

# # Create a firewall rule
# resource "civo_firewall_rule" "kubernetes" {
#     firewall_id = civo_firewall.brodin-firewall.id
#     protocol = "tcp"
#     start_port = "6443"
#     end_port = "6443"
#     cidr = ["0.0.0.0/0"]
#     direction = "ingress"
#     label = "kubernetes-api-server"
#     action = "allow"
# }

# # Create a cluster with k3s
# resource "civo_kubernetes_cluster" "brodin" {
#     name = "brodin"
#     # applications = "Portainer,Linkerd:Linkerd & Jaeger"
#     firewall_id = civo_firewall.brodin-firewall.id
#     cluster_type = "k3s"
#     pools {
#         label = "main" // Optional
#         size = element(data.civo_size.xsmall.sizes, 0).name
#         node_count = 3
#     }
# }