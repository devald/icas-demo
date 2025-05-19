## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.11.4 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.36.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | >= 2.36.0 |

## Resources

| Name | Type |
|------|------|
| [kubernetes_job_v1.crawler](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/job_v1) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_eks_ca_data"></a> [eks\_ca\_data](#input\_eks\_ca\_data) | Base64-encoded certificate authority data for the EKS cluster. | `string` | n/a | yes |
| <a name="input_eks_cluster_endpoint"></a> [eks\_cluster\_endpoint](#input\_eks\_cluster\_endpoint) | API server endpoint URL of the EKS cluster. | `string` | n/a | yes |
| <a name="input_eks_cluster_name"></a> [eks\_cluster\_name](#input\_eks\_cluster\_name) | Name of the EKS cluster to connect to. | `string` | n/a | yes |
| <a name="input_s3_bucket_name"></a> [s3\_bucket\_name](#input\_s3\_bucket\_name) | Name of the S3 bucket where the crawler job will upload the downloaded HTML content. | `string` | n/a | yes |
| <a name="input_target_website_url"></a> [target\_website\_url](#input\_target\_website\_url) | The URL of the website that the crawler job will download and upload to the S3 bucket. | `string` | `"https://terragrunt.gruntwork.io"` | no |
