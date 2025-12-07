# 3-Tier Infrastructure with Terragrunt

This repository contains Terraform infrastructure code for a 3-tier application architecture deployed using Terragrunt.

## Architecture

- **Frontend**: Application Load Balancer (ALB) in public subnets
- **Backend**: Internal ALB in private subnets
- **Database**: RDS MySQL instance in private subnets
- **Networking**: VPC with public and private subnets, NAT Gateways
- **Security**: Security groups, IAM roles

## Structure

```
.
├── modules/              # Reusable Terraform modules
│   ├── alb/             # Application Load Balancer
│   ├── asg/             # Auto Scaling Groups
│   ├── iam/             # IAM roles and policies
│   ├── infrastructure/  # Main infrastructure module
│   ├── rds/             # RDS database
│   ├── sg/              # Security groups
│   └── vpc/             # VPC and networking
├── envs/                # Environment-specific configurations
│   ├── dev/            # Development environment
│   ├── stage/          # Staging environment
│   └── prod/           # Production environment
└── terragrunt.hcl      # Root Terragrunt configuration
```

## Prerequisites

- Terraform >= 1.0
- Terragrunt
- AWS CLI configured
- Vault (for RDS secrets)

## Setup

1. **Clone the repository**
   ```bash
   git clone <your-repo-url>
   cd 3-tier-infra
   ```

2. **Set up Vault credentials** (for RDS secrets)
   ```bash
   export VAULT_ADDR="http://127.0.0.1:8200"
   export VAULT_ROLE_ID="your-role-id"
   export VAULT_SECRET_ID="your-secret-id"
   ```

3. **Create S3 bucket for Terraform state**
   - Bucket name: `my-ayush-terraform-state-bucket`
   - DynamoDB table: `ayush-terraform-lock`
   - Region: `ap-south-1` (or your preferred region)

## Usage

### Deploy to Development Environment

```bash
cd envs/dev
terragrunt plan
terragrunt apply
```

### Deploy to Production Environment

```bash
cd envs/prod
terragrunt plan
terragrunt apply
```

### Destroy Infrastructure

```bash
cd envs/dev
terragrunt destroy
```

## Environment Variables

Each environment requires Vault credentials:

- `VAULT_ADDR`: Vault server address
- `VAULT_ROLE_ID`: Vault AppRole role ID
- `VAULT_SECRET_ID`: Vault AppRole secret ID

## Outputs

After deployment, get outputs:

```bash
cd envs/dev
terragrunt output
```

You'll get:
- `external_alb_dns_name`: Frontend ALB URL
- `internal_alb_dns_name`: Backend ALB URL (internal)
- `rds_endpoint`: RDS database endpoint

## Configuration

### Environment-Specific Settings

Edit `envs/<env>/terragrunt.hcl` to customize:
- Instance types
- CIDR blocks
- Subnet counts
- Database instance class
- AMI IDs

### Root Configuration

Edit `terragrunt.hcl` to configure:
- S3 backend bucket
- DynamoDB lock table
- AWS region

## Security Notes

- Never commit `.tfstate` files
- Never commit Vault credentials
- Use environment variables for sensitive data
- Review security group rules before applying

## Troubleshooting

See `VERIFICATION_STEPS.md` for verification and troubleshooting steps.

## License

[Your License Here]

