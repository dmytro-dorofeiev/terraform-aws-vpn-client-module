resource "tls_private_key" "ca" {
  algorithm = "RSA"
}

resource "tls_self_signed_cert" "ca" {
  key_algorithm   = "RSA"
  private_key_pem = tls_private_key.ca.private_key_pem

  subject {
    common_name  = "${var.name}.vpn.ca"
    organization = var.organization_name
  }

  validity_period_hours = 87600
  is_ca_certificate     = true

  allowed_uses = [
    "cert_signing",
    "crl_signing",
  ]
}

resource "aws_acm_certificate" "ca" {
  private_key      = tls_private_key.ca.private_key_pem
  certificate_body = tls_self_signed_cert.ca.cert_pem
}

# resource "local_file" "ca_key" {
#   content  = tls_private_key.ca.private_key_pem
#   filename = "${path.module}/certs/acme_ca_private_key.pem"
# }

resource "aws_secretsmanager_secret" "ca_key" {
  description             = "CA key for openvpn"
  name                    = "${var.name}_ca_openvpn_key"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "ca_key" {
  secret_id     = aws_secretsmanager_secret.ca_key.id
  secret_string = tls_private_key.ca.private_key_pem
}
