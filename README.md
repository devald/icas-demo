# ICAS Demo Infrastructure

This is a fully reproducible, Terragrunt-based infrastructure deployment demo managed using Nix flakes. It is configured for a demo AWS account and deploys a full stack including VPC, EKS, job modules, and S3 storage using GitHub Actions and OIDC authentication.

## 🧱 Stack Components

This infrastructure includes:

- **Terragrunt + Terraform Modules**:
  - `aws-data`: AWS region/account data source
  - `vpc-1`: Custom VPC for demo workloads
  - `eks-1`: Kubernetes cluster (EKS)
  - `crawler-job-1`: Sample workload running in Kubernetes
  - `crawler-s3-1`: S3 bucket for crawler storage
  - `github-oidc`: IAM roles for GitHub OIDC authentication

- **Live Environment**: `live/demo/eu-central-1/`
  - Organized by AWS region and account
  - Each component has its own `terragrunt.hcl`

- **Nix Flake**: Development environment and automation
  - `nix develop`: provides pinned versions of Terraform, Terragrunt, kubectl, and AWS CLI
  - `nix run .#validate`: validates HCL and Terraform format
  - `nix run .#apply`: applies all Terragrunt modules

## 🚀 Deployment

Deployment is fully automated through GitHub Actions using OIDC:

```yaml
- uses: aws-actions/configure-aws-credentials@v4
  with:
    role-to-assume: arn:aws:iam::767140398543:role/github-oidc-terraform
    aws-region: eu-central-1
```

GitHub workflow is located in:
```
.github/workflows/deploy.yml
```

It:
1. Installs Nix
2. Authenticates with AWS via OIDC
3. Runs `nix run .#validate`
4. Runs `nix run .#apply`

## 🧪 Validation & Formatting

Validation is handled via the `validate` app:

```bash
nix run .#validate
```

Which checks:
- `terraform fmt -recursive -check`
- `terragrunt hcl fmt --check`
- `terragrunt hcl validate` (with exit code checking)

## 🔧 Local Development

You can enter the development shell with:

```bash
nix develop
```

This provides:
- Terraform
- Terragrunt
- AWS CLI
- kubectl

With the following env vars set:

```bash
AWS_PROFILE=demo-profile
AWS_REGION=eu-central-1
TG_PROVIDER_CACHE=1
```

## 📁 Project Structure

```
.
├── flake.nix
├── root.hcl
├── live/
│   └── demo/
│       └── eu-central-1/
│           ├── aws-data/
│           ├── vpc-1/
│           ├── eks-1/
│           ├── crawler-job-1/
│           ├── crawler-s3-1/
│           └── github-oidc/
├── modules/
│   ├── aws-data/
│   ├── crawler-job/
│   └── github-oidc/
└── .github/
    └── workflows/
        └── deploy.yml
```

---