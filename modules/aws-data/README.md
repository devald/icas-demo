

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_available_aws_availability_zones_names"></a> [available\_aws\_availability\_zones\_names](#output\_available\_aws\_availability\_zones\_names) | Names of all available Availability Zones in the selected region for the current AWS account. |
| <a name="output_available_aws_availability_zones_zone_ids"></a> [available\_aws\_availability\_zones\_zone\_ids](#output\_available\_aws\_availability\_zones\_zone\_ids) | Unique identifiers (Zone IDs) of all available Availability Zones in the selected region for the current AWS account. |
| <a name="output_aws_region"></a> [aws\_region](#output\_aws\_region) | Information about the currently selected AWS region, including its name and metadata. |
