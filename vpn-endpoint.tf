resource "aws_iam_saml_provider" "okta_provider" {
  name                   = "Okta-VPN"
  saml_metadata_document = file("${path.module}/files/saml-metadata.xml")
}

resource "aws_ec2_client_vpn_endpoint" "default" {
  description            = "${var.name}-client-vpn"
  server_certificate_arn = aws_acm_certificate.server.arn
  client_cidr_block      = var.cidr
  split_tunnel           = var.split_tunnel
  transport_protocol     = "udp"

  dynamic "authentication_options" {
    for_each = var.auth_settings
    content {
      type                       = lookup(var.auth_settings, "type", null)
      active_directory_id        = lookup(var.auth_settings, "active_directory_id", null)
      root_certificate_chain_arn = lookup(var.auth_settings, "root_certificate_chain_arn", null)
      saml_provider_arn          = lookup(var.auth_settings, "saml_provider_arn", null)
    }
  }

  connection_log_options {
    enabled               = true
    cloudwatch_log_group  = aws_cloudwatch_log_group.vpn.name
    cloudwatch_log_stream = aws_cloudwatch_log_stream.vpn.name
  }

  tags = merge(
    var.tags,
    map(
      "Name", "${var.name}-client-vpn"
    )
  )
}

resource "aws_ec2_client_vpn_network_association" "default" {
  for_each               = toset(var.subnet_ids)
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.default.id
  subnet_id              = each.key
  security_groups        = [aws_security_group.client_vpn_access.id]
}

resource "aws_ec2_client_vpn_authorization_rule" "default" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.default.id
  target_network_cidr    = var.auth_target_network_cidr
  authorize_all_groups   = true
}

// Here could be manage routes and groups authorization
# resource "aws_ec2_client_vpn_authorization_rule" "development" {
#   client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.this.id
#   target_network_cidr    = "172.100.0.0/16"
#   access_group_id        = var.developer_group_id
#   description            = "Authorization to AD group developer for development vpc"
# }

# resource "aws_ec2_client_vpn_authorization_rule" "production" {
#   client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.this.id
#   target_network_cidr    = "172.110.0.0/16"
#   access_group_id        = var.analyst_group_id
#   description            = "Authorization to AD group analyst for production vpc"
# }

# resource "aws_ec2_client_vpn_route" "production" {
#   client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.this.id
#   destination_cidr_block = "172.110.0.0/16"
#   target_vpc_subnet_id   = aws_ec2_client_vpn_network_association.this.subnet_id
# }
