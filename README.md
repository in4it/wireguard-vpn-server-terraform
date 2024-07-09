# WireGuard VPN Server

## Features
* Web UI for administration and to download the WireGuard configuration files
* SAML Support
* OIDC Support
* SCIM Support for provisioning
* EFS to persist configuration

## Usage

Make sure to subscribe first to the Marketplace product at [https://aws.amazon.com/marketplace/pp/prodview-dymnyb6a2pq72](https://aws.amazon.com/marketplace/pp/prodview-dymnyb6a2pq72)

```
module "vpn-server" {
	source             = "https://github.com/in4it/wireguard-vpn-server-terraform"
	instance_type      = "t3.small"
	vpc_id             = module.vpc.vpc_id
	instance_subnet_id = module.vpc.public_subnets[0]
	efs_subnet_ids     = [module.vpc.public_subnets[0]]
}

# example from https://github.com/terraform-aws-modules/terraform-aws-vpc
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "my-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = true

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}

```

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_efs_file_system.vpn-server-config](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_file_system) | resource |
| [aws_efs_mount_target.vpn-server-config](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_mount_target) | resource |
| [aws_eip.vpn-server](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_iam_instance_profile.vpn-server](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_role.vpn-server-iam-role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.vpn-iam-policy-attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_instance.vpn-server](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_security_group.vpn-efs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.vpn-server](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_ami.vpn-server](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_efs_subnet_ids"></a> [efs\_subnet\_ids](#input\_efs\_subnet\_ids) | subnets to create the efs mountpoints in | `any` | n/a | yes |
| <a name="input_env"></a> [env](#input\_env) | n/a | `string` | `"prod"` | no |
| <a name="input_instance_profile_name"></a> [instance\_profile\_name](#input\_instance\_profile\_name) | use a custom instance profile | `string` | `""` | no |
| <a name="input_instance_subnet_id"></a> [instance\_subnet\_id](#input\_instance\_subnet\_id) | subnet to launch the VPN Server in | `any` | n/a | yes |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | n/a | `string` | `"t3.small"` | no |
| <a name="input_listeners"></a> [listeners](#input\_listeners) | n/a | <pre>list(object({<br>    port        = string<br>    protocol    = string<br>    cidr_blocks = list(string)<br>  }))</pre> | <pre>[<br>  {<br>    "cidr_blocks": [<br>      "0.0.0.0/0"<br>    ],<br>    "port": "51820",<br>    "protocol": "udp"<br>  },<br>  {<br>    "cidr_blocks": [<br>      "0.0.0.0/0"<br>    ],<br>    "port": "80",<br>    "protocol": "tcp"<br>  },<br>  {<br>    "cidr_blocks": [<br>      "0.0.0.0/0"<br>    ],<br>    "port": "443",<br>    "protocol": "tcp"<br>  }<br>]</pre> | no |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(string)` | `{}` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC id to launch the VPN Server in | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_vpn-ip"></a> [vpn-ip](#output\_vpn-ip) | n/a |
| <a name="output_vpn-sg"></a> [vpn-sg](#output\_vpn-sg) | n/a |
