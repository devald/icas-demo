output "aws_region" {
  description = "Information about the currently selected AWS region, including its name and metadata."
  value       = data.aws_region.current
}

output "available_aws_availability_zones_names" {
  description = "Names of all available Availability Zones in the selected region for the current AWS account."
  value       = data.aws_availability_zones.available.names
}

output "available_aws_availability_zones_zone_ids" {
  description = "Unique identifiers (Zone IDs) of all available Availability Zones in the selected region for the current AWS account."
  value       = data.aws_availability_zones.available.zone_ids
}
