output "client_vpn_endpoint_arn" {
  description = "The ARN of the Client VPN endpoint."
  value       = aws_ec2_client_vpn_endpoint.default.arn
}

output "client_vpn_endpoint_id" {
  description = "The ID of the Client VPN endpoint."
  value       = aws_ec2_client_vpn_endpoint.default.id
}

output "okta_provider_arn" {
  description = "The ID of the Client VPN endpoint."
  value       = aws_iam_saml_provider.okta_provider.arn
}
