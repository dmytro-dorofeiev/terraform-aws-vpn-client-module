# Terraform aws vpn client module

## About

This module creates AWS vpn client endpoint with 2MFA using Okta (could be disabled).
It also contains script create_user.sh that make it easier to create client certificates.

## Examples

```hcl
## VPC
data "aws_vpc" "default" {
  filter {
    name   = "tag:Name"
    values = ["dev-vpc"]
  }
}

data "aws_subnet_ids" "public" {
  vpc_id = data.aws_vpc.default.id

  tags = {
    Name = "*public*"
  }
}

module "vpn-client" {
  source = "../modules/terraform-aws-vpn-client-module"
  cidr = var.vpn_cidr
  auth_target_network_cidr = var.target_network_cidr
  name = var.vpn_name
  subnet_ids = data.aws_subnet_ids.public.ids
  vpc_id = data.aws_vpc.default.id
}

output "client_vpn_endpoint_id" {
  description = "The ID of the Client VPN endpoint."
  value       = module.vpn-client.client_vpn_endpoint_id
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 3.32.0 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | 3.1.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_acm_certificate.ca](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate) | resource |
| [aws_acm_certificate.server](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate) | resource |
| [aws_cloudwatch_log_group.vpn](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_stream.vpn](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_stream) | resource |
| [aws_ec2_client_vpn_authorization_rule.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_client_vpn_authorization_rule) | resource |
| [aws_ec2_client_vpn_endpoint.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_client_vpn_endpoint) | resource |
| [aws_ec2_client_vpn_network_association.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_client_vpn_network_association) | resource |
| [aws_iam_saml_provider.okta_provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_saml_provider) | resource |
| [aws_secretsmanager_secret.ca_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_version.ca_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_security_group.client_vpn_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [tls_cert_request.server](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/cert_request) | resource |
| [tls_locally_signed_cert.server](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/locally_signed_cert) | resource |
| [tls_private_key.ca](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [tls_private_key.server](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [tls_self_signed_cert.ca](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/self_signed_cert) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_auth_settings"></a> [auth\_settings](#input\_auth\_settings) | VPN authentication options | `map(any)` | `{}` | no |
| <a name="input_auth_target_network_cidr"></a> [auth\_target\_network\_cidr](#input\_auth\_target\_network\_cidr) | The IPv4 address range, in CIDR notation, of the network to which the authorization rule applies | `string` | `"0.0.0.0/0"` | no |
| <a name="input_cidr"></a> [cidr](#input\_cidr) | Network CIDR to use for clients | `any` | n/a | yes |
| <a name="input_logs_retention"></a> [logs\_retention](#input\_logs\_retention) | Retention in days for CloudWatch Log Group | `number` | `365` | no |
| <a name="input_name"></a> [name](#input\_name) | Name prefix for the resources of this stack | `any` | n/a | yes |
| <a name="input_organization_name"></a> [organization\_name](#input\_organization\_name) | Name of organization to use in private certificate | `string` | `"ACME, Inc"` | no |
| <a name="input_split_tunnel"></a> [split\_tunnel](#input\_split\_tunnel) | Indicates whether split-tunnel is enabled on VPN endpoint | `bool` | `true` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | Subnet ID to associate clients | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Extra tags to attach to resources | `map(string)` | `{}` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC id | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_client_vpn_endpoint_arn"></a> [client\_vpn\_endpoint\_arn](#output\_client\_vpn\_endpoint\_arn) | The ARN of the Client VPN endpoint. |
| <a name="output_client_vpn_endpoint_id"></a> [client\_vpn\_endpoint\_id](#output\_client\_vpn\_endpoint\_id) | The ID of the Client VPN endpoint. |
| <a name="output_okta_provider_arn"></a> [okta\_provider\_arn](#output\_okta\_provider\_arn) | The ID of the Client VPN endpoint. |
