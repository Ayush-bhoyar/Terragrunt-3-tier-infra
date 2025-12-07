# Verification Steps for 3-Tier Infrastructure

## Step 1: Get Your Endpoints

Run this command to get all endpoints:
```bash
cd /root/3-tier-infra/envs/dev
terragrunt output
```

You'll get:
- `external_alb_dns_name` - Frontend URL
- `internal_alb_dns_name` - Backend URL (internal only)
- `rds_endpoint` - RDS database endpoint

---

## Step 2: Verify Frontend (External ALB)

The frontend is accessible from the internet.

### Option A: Using curl (from your local machine or server)
```bash
curl http://<EXTERNAL_ALB_DNS_NAME>
```

### Option B: Using browser
1. Open your web browser
2. Navigate to: `http://<EXTERNAL_ALB_DNS_NAME>`
3. You should see your frontend application

### Option C: Check HTTP status
```bash
curl -I http://<EXTERNAL_ALB_DNS_NAME>
# Should return HTTP 200 OK
```

---

## Step 3: Verify Backend (Internal ALB)

The backend is **only accessible from within the VPC** (private).

### Option A: SSH into an EC2 instance in your VPC
```bash
# 1. Get an EC2 instance ID from your ASG
aws ec2 describe-instances \
  --filters "Name=tag:Name,Values=*backend*" \
  --query 'Reservations[*].Instances[*].[InstanceId,PublicIpAddress,PrivateIpAddress]' \
  --output table

# 2. SSH into the instance (if it has a public IP)
ssh -i your-key.pem ec2-user@<PUBLIC_IP>

# 3. From inside the instance, test the backend
curl http://<INTERNAL_ALB_DNS_NAME>
```

### Option B: Use AWS Systems Manager Session Manager
```bash
# 1. Get instance ID
aws ec2 describe-instances \
  --filters "Name=tag:Name,Values=*backend*" \
  --query 'Reservations[*].Instances[*].InstanceId' \
  --output text

# 2. Start session
aws ssm start-session --target <INSTANCE_ID>

# 3. Test backend
curl http://<INTERNAL_ALB_DNS_NAME>
```

### Option C: From a bastion host or VPN connection
If you have a bastion host or VPN connected to your VPC, you can access the internal ALB from there.

---

## Step 4: Verify RDS is Using Vault Credentials

### Step 4.1: Check what's in Vault
```bash
# Make sure you're authenticated to Vault
export VAULT_ADDR="http://127.0.0.1:8200"
export VAULT_ROLE_ID="your-role-id"
export VAULT_SECRET_ID="your-secret-id"

# Get the secret from Vault
vault kv get kv/rds-secret
```

You should see:
- `username`: e.g., "newadmin"
- `password`: e.g., "Ayush2607"

### Step 4.2: Check what Terraform used (from state)
```bash
cd /root/3-tier-infra/envs/dev

# Check the Vault data source
terragrunt run -- state show 'module.infrastructure.module.RDS.data.vault_kv_secret_v2.rds_secret'

# Check the RDS instance configuration
terragrunt run -- state show 'module.infrastructure.module.RDS.aws_db_instance.mysql_rds' | grep username
```

### Step 4.3: Connect to RDS and verify username
```bash
# Install MySQL client if needed
# yum install mysql -y  # For RHEL/CentOS
# apt-get install mysql-client -y  # For Ubuntu/Debian

# Connect to RDS using Vault credentials
mysql -h <RDS_ENDPOINT> -u <VAULT_USERNAME> -p
# Enter the password from Vault when prompted

# Once connected, verify:
mysql> SELECT USER();
# Should show the username from Vault
```

### Step 4.4: Verify from Terraform code
Check that RDS is configured to use Vault:
```bash
cat /root/3-tier-infra/modules/rds/main.tf | grep -A 2 "username\|password"
```

You should see:
```terraform
username = data.vault_kv_secret_v2.rds_secret.data["username"]
password = data.vault_kv_secret_v2.rds_secret.data["password"]
```

---

## Quick Verification Script

Save this as `verify.sh` and run it:

```bash
#!/bin/bash

echo "=== Getting Endpoints ==="
cd /root/3-tier-infra/envs/dev
EXTERNAL_ALB=$(terragrunt output -raw external_alb_dns_name)
INTERNAL_ALB=$(terragrunt output -raw internal_alb_dns_name)
RDS_ENDPOINT=$(terragrunt output -raw rds_endpoint)

echo "External ALB: $EXTERNAL_ALB"
echo "Internal ALB: $INTERNAL_ALB"
echo "RDS Endpoint: $RDS_ENDPOINT"

echo ""
echo "=== Testing Frontend ==="
curl -s -o /dev/null -w "Frontend Status: %{http_code}\n" http://$EXTERNAL_ALB

echo ""
echo "=== Checking Vault Secret ==="
vault kv get kv/rds-secret 2>/dev/null | grep -E "username|password" || echo "Vault not accessible"

echo ""
echo "=== RDS Configuration ==="
echo "RDS Endpoint: $RDS_ENDPOINT"
echo "To connect: mysql -h $RDS_ENDPOINT -u <vault-username> -p"
```

---

## Summary Checklist

- [ ] Frontend accessible via external ALB (HTTP 200)
- [ ] Backend accessible via internal ALB (from within VPC)
- [ ] Vault secret contains username and password
- [ ] RDS instance uses username from Vault (check Terraform state)
- [ ] Can connect to RDS using Vault credentials

