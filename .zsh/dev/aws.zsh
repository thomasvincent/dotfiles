#!/usr/bin/env zsh
# =============================================================================
# AWS CLI Workflows and Aliases
# =============================================================================
#
# File: ~/.zsh/dev/aws.zsh
# Purpose: Comprehensive AWS CLI tooling for cloud operations
# Dependencies: aws-cli, jq, fzf (optional), aws-vault (optional)
#
# This module provides:
#   - Extensive AWS CLI aliases for common services
#   - Profile management with fuzzy selection
#   - SSO authentication helpers
#   - Interactive instance/resource selection
#   - Cost exploration tools
#
# Setup:
#   1. Install AWS CLI: brew install awscli
#   2. Configure: aws configure
#   3. (Optional) Install aws-vault for secure credential management
#
# =============================================================================

# =============================================================================
# AWS ALIASES
# =============================================================================
#
# Organized by AWS service. These aliases provide quick access to
# commonly used commands with sensible default output formats.
#
# Many aliases use --query and --output table for readable output.
# You can pipe to jq for JSON processing when needed.
#
# =============================================================================

if command -v aws &>/dev/null; then
  # ---------------------------------------------------------------------------
  # General / IAM
  # ---------------------------------------------------------------------------
  alias awsw='aws sts get-caller-identity'   # "Who am I?" - shows account/user
  alias awsr='aws configure list'             # Show current config
  
  # IAM Users and Roles
  alias iamls='aws iam list-users --query "Users[*].{Name:UserName,Created:CreateDate}" --output table'
  alias iamroles='aws iam list-roles --query "Roles[*].{Name:RoleName,Created:CreateDate}" --output table'
  
  # ---------------------------------------------------------------------------
  # EC2 - Elastic Compute Cloud
  # ---------------------------------------------------------------------------
  # List all instances with key info
  alias ec2ls='aws ec2 describe-instances --query "Reservations[*].Instances[*].{ID:InstanceId,Type:InstanceType,State:State.Name,Name:Tags[?Key==\`Name\`]|[0].Value,IP:PrivateIpAddress,PublicIP:PublicIpAddress}" --output table'
  
  # List only running instances
  alias ec2run='aws ec2 describe-instances --filters "Name=instance-state-name,Values=running" --query "Reservations[*].Instances[*].{ID:InstanceId,Name:Tags[?Key==\`Name\`]|[0].Value,Type:InstanceType,IP:PrivateIpAddress}" --output table'
  
  # Start/stop instances (provide instance ID as argument)
  alias ec2stop='aws ec2 stop-instances --instance-ids'
  alias ec2start='aws ec2 start-instances --instance-ids'
  
  # SSM Session Manager (more secure than SSH)
  alias ec2ssh='aws ssm start-session --target'
  
  # ---------------------------------------------------------------------------
  # S3 - Simple Storage Service
  # ---------------------------------------------------------------------------
  alias s3ls='aws s3 ls'                     # List buckets or objects
  alias s3cp='aws s3 cp'                     # Copy files
  alias s3sync='aws s3 sync'                 # Sync directories
  alias s3rm='aws s3 rm'                     # Remove objects
  alias s3mb='aws s3 mb'                     # Make bucket
  alias s3rb='aws s3 rb'                     # Remove bucket
  
  # ---------------------------------------------------------------------------
  # ECS - Elastic Container Service
  # ---------------------------------------------------------------------------
  alias ecsls='aws ecs list-clusters --output table'
  alias ecssvc='aws ecs list-services --cluster'    # Requires cluster name
  alias ecstasks='aws ecs list-tasks --cluster'     # Requires cluster name
  
  # ---------------------------------------------------------------------------
  # EKS - Elastic Kubernetes Service
  # ---------------------------------------------------------------------------
  alias eksls='aws eks list-clusters --output table'
  alias eksup='aws eks update-kubeconfig --name'    # Update kubeconfig for cluster
  
  # ---------------------------------------------------------------------------
  # Lambda
  # ---------------------------------------------------------------------------
  alias lambdals='aws lambda list-functions --query "Functions[*].{Name:FunctionName,Runtime:Runtime,Memory:MemorySize,Timeout:Timeout}" --output table'
  alias lambdalog='aws logs tail --follow'   # Tail log group
  
  # ---------------------------------------------------------------------------
  # RDS - Relational Database Service
  # ---------------------------------------------------------------------------
  alias rdsls='aws rds describe-db-instances --query "DBInstances[*].{ID:DBInstanceIdentifier,Engine:Engine,Class:DBInstanceClass,Status:DBInstanceStatus}" --output table'
  
  # ---------------------------------------------------------------------------
  # CloudFormation
  # ---------------------------------------------------------------------------
  # List stacks (excluding deleted)
  alias cfnls='aws cloudformation list-stacks --query "StackSummaries[?StackStatus!=\`DELETE_COMPLETE\`].{Name:StackName,Status:StackStatus}" --output table'
  alias cfnevents='aws cloudformation describe-stack-events --stack-name'
  
  # ---------------------------------------------------------------------------
  # SSM - Systems Manager
  # ---------------------------------------------------------------------------
  alias ssmls='aws ssm describe-instance-information --query "InstanceInformationList[*].{ID:InstanceId,Name:ComputerName,Platform:PlatformType,Status:PingStatus}" --output table'
  alias ssmsh='aws ssm start-session --target'
  alias ssmcmd='aws ssm send-command'
  
  # ---------------------------------------------------------------------------
  # CloudWatch Logs
  # ---------------------------------------------------------------------------
  alias cwlogs='aws logs describe-log-groups --query "logGroups[*].logGroupName" --output table'
  alias cwtail='aws logs tail --follow'
fi

# =============================================================================
# AWS PROFILE MANAGEMENT
# =============================================================================
#
# These functions help manage multiple AWS profiles and credentials.
# They work with both traditional credentials and SSO.
#
# =============================================================================

# -----------------------------------------------------------------------------
# aws-profiles: List all configured AWS profiles
# -----------------------------------------------------------------------------
#
# Shows profiles from ~/.aws/credentials and the current active profile.
#
# Usage:
#   aws-profiles
#
# Output:
#   Available AWS Profiles:
#   default
#   production
#   development
#
#   Current profile: development
#
# -----------------------------------------------------------------------------
aws-profiles() {
  echo "Available AWS Profiles:"
  grep '\[' ~/.aws/credentials 2>/dev/null | tr -d '[]'
  echo ""
  echo "Current profile: ${AWS_PROFILE:-default}"
}

# -----------------------------------------------------------------------------
# aws-profile: Switch AWS profile
# -----------------------------------------------------------------------------
#
# Sets the AWS_PROFILE environment variable. With fzf installed,
# provides interactive selection.
#
# Usage:
#   aws-profile              # Interactive selection
#   aws-profile production   # Switch to specific profile
#
# After switching, verifies the new identity with sts get-caller-identity.
#
# -----------------------------------------------------------------------------
aws-profile() {
  local profile="$1"
  
  # Interactive selection if no profile specified and fzf available
  if [[ -z "$profile" ]]; then
    if command -v fzf &>/dev/null; then
      profile=$(grep '\[' ~/.aws/credentials 2>/dev/null | tr -d '[]' | fzf --height 40% --prompt="Select AWS profile: ")
    else
      aws-profiles
      echo ""
      echo "Usage: aws-profile <profile-name>"
      return 0
    fi
  fi
  
  if [[ -n "$profile" ]]; then
    export AWS_PROFILE="$profile"
    echo "✅ Switched to AWS profile: $profile"
    echo ""
    # Verify the identity with the new profile
    aws sts get-caller-identity
  fi
}

# -----------------------------------------------------------------------------
# aws-sso-login: Authenticate with AWS SSO
# -----------------------------------------------------------------------------
#
# Initiates SSO login flow for a profile. Opens browser for authentication.
# After login, sets the profile as active.
#
# Usage:
#   aws-sso-login            # Login with current profile
#   aws-sso-login prod-sso   # Login with specific profile
#
# -----------------------------------------------------------------------------
aws-sso-login() {
  local profile="${1:-$AWS_PROFILE}"
  
  if [[ -z "$profile" ]]; then
    echo "Usage: aws-sso-login <profile>"
    echo "Or set AWS_PROFILE first"
    return 1
  fi
  
  echo "🔐 Logging into AWS SSO for profile: $profile"
  aws sso login --profile "$profile"
  export AWS_PROFILE="$profile"
  echo "✅ SSO login complete. Profile set to: $profile"
}

# =============================================================================
# AWS FUNCTIONS
# =============================================================================
#
# Higher-level functions that combine multiple AWS operations or add
# interactive selection capabilities.
#
# =============================================================================

# -----------------------------------------------------------------------------
# ec2-by-name: Find EC2 instances by Name tag
# -----------------------------------------------------------------------------
#
# Searches for instances where the Name tag contains the specified pattern.
# Uses wildcard matching so partial names work.
#
# Usage:
#   ec2-by-name web          # Find instances with "web" in name
#   ec2-by-name prod-api     # Find instances with "prod-api" in name
#
# -----------------------------------------------------------------------------
ec2-by-name() {
  local name="$1"
  if [[ -z "$name" ]]; then
    echo "Usage: ec2-by-name <instance-name-pattern>"
    echo "  Searches Name tag with wildcards"
    return 1
  fi
  
  echo "🔍 Searching for instances matching: *${name}*"
  aws ec2 describe-instances \
    --filters "Name=tag:Name,Values=*${name}*" \
    --query 'Reservations[*].Instances[*].{ID:InstanceId,Name:Tags[?Key==`Name`]|[0].Value,State:State.Name,IP:PrivateIpAddress,Type:InstanceType}' \
    --output table
}

# -----------------------------------------------------------------------------
# ec2-ssm: Connect to EC2 instance via SSM Session Manager
# -----------------------------------------------------------------------------
#
# More secure than SSH - no need to manage SSH keys or open port 22.
# Requires SSM agent running on instance and proper IAM permissions.
#
# Usage:
#   ec2-ssm                  # Interactive selection from running instances
#   ec2-ssm i-1234567890     # Connect to specific instance
#
# Prerequisites:
#   - Instance must have SSM agent installed and running
#   - Instance must have IAM role with AmazonSSMManagedInstanceCore policy
#   - Session Manager plugin installed locally
#
# -----------------------------------------------------------------------------
ec2-ssm() {
  local instance="$1"
  
  # If no instance specified, show interactive selection
  if [[ -z "$instance" ]]; then
    echo "🔍 Fetching running instances..."
    
    if command -v fzf &>/dev/null; then
      # Use fzf for interactive selection
      instance=$(
        aws ec2 describe-instances \
          --filters "Name=instance-state-name,Values=running" \
          --query 'Reservations[*].Instances[*].[InstanceId,Tags[?Key==`Name`]|[0].Value]' \
          --output text | fzf --height 40% --prompt="Select instance: " | awk '{print $1}'
      )
    else
      # No fzf, just show the list
      aws ec2 describe-instances \
        --filters "Name=instance-state-name,Values=running" \
        --query 'Reservations[*].Instances[*].{ID:InstanceId,Name:Tags[?Key==`Name`]|[0].Value}' \
        --output table
      echo ""
      echo "Usage: ec2-ssm <instance-id>"
      return 0
    fi
  fi
  
  if [[ -n "$instance" ]]; then
    echo "💻 Connecting to: $instance"
    aws ssm start-session --target "$instance"
  fi
}

# -----------------------------------------------------------------------------
# s3-size: Get the total size of an S3 bucket
# -----------------------------------------------------------------------------
#
# Lists all objects in a bucket and shows total size.
# Note: Can be slow for very large buckets.
#
# Usage:
#   s3-size my-bucket
#
# -----------------------------------------------------------------------------
s3-size() {
  local bucket="$1"
  if [[ -z "$bucket" ]]; then
    echo "Usage: s3-size <bucket-name>"
    return 1
  fi
  
  echo "📦 Calculating size of bucket: $bucket"
  aws s3 ls "s3://$bucket" --recursive --summarize --human-readable | tail -2
}

# -----------------------------------------------------------------------------
# cw-logs: Tail CloudWatch log group
# -----------------------------------------------------------------------------
#
# Streams logs from a CloudWatch log group. With fzf, provides
# interactive log group selection.
#
# Usage:
#   cw-logs                          # Interactive selection
#   cw-logs /aws/lambda/my-fn       # Specific log group
#   cw-logs /aws/lambda/my-fn 60    # Last 60 minutes
#
# -----------------------------------------------------------------------------
cw-logs() {
  local log_group="$1"
  local minutes="${2:-30}"  # Default to last 30 minutes
  
  if [[ -z "$log_group" ]]; then
    if command -v fzf &>/dev/null; then
      echo "🔍 Fetching log groups..."
      log_group=$(
        aws logs describe-log-groups \
          --query 'logGroups[*].logGroupName' \
          --output text | tr '\t' '\n' | fzf --height 40% --prompt="Select log group: "
      )
    else
      echo "Usage: cw-logs <log-group-name> [minutes-ago]"
      echo ""
      echo "Available log groups:"
      aws logs describe-log-groups --query 'logGroups[*].logGroupName' --output table
      return 1
    fi
  fi
  
  if [[ -n "$log_group" ]]; then
    echo "📜 Tailing logs from: $log_group (last $minutes minutes)"
    aws logs tail "$log_group" --since "${minutes}m" --follow
  fi
}

# -----------------------------------------------------------------------------
# eks-config: Update kubeconfig for EKS cluster
# -----------------------------------------------------------------------------
#
# Updates ~/.kube/config with credentials for an EKS cluster.
# After running, you can use kubectl with the cluster.
#
# Usage:
#   eks-config                       # Interactive selection
#   eks-config my-cluster            # Specific cluster
#   eks-config my-cluster us-east-1  # Cluster in specific region
#
# -----------------------------------------------------------------------------
eks-config() {
  local cluster="$1"
  local region="${2:-us-west-2}"  # Default region
  
  if [[ -z "$cluster" ]]; then
    if command -v fzf &>/dev/null; then
      echo "🔍 Fetching EKS clusters..."
      cluster=$(
        aws eks list-clusters \
          --query 'clusters[*]' \
          --output text | tr '\t' '\n' | fzf --height 40% --prompt="Select EKS cluster: "
      )
    else
      echo "Available EKS clusters:"
      aws eks list-clusters --output table
      echo ""
      echo "Usage: eks-config <cluster-name> [region]"
      return 0
    fi
  fi
  
  if [[ -n "$cluster" ]]; then
    echo "⚙️  Updating kubeconfig for cluster: $cluster"
    aws eks update-kubeconfig --name "$cluster" --region "$region"
    echo "✅ kubeconfig updated. Current context:"
    kubectl config current-context
  fi
}

# -----------------------------------------------------------------------------
# lambda-logs: Tail Lambda function logs
# -----------------------------------------------------------------------------
#
# Convenience wrapper for CloudWatch logs specific to Lambda functions.
# Lambda logs are in /aws/lambda/{function-name} log groups.
#
# Usage:
#   lambda-logs                      # Interactive selection
#   lambda-logs my-function          # Specific function
#   lambda-logs my-function 60       # Last 60 minutes
#
# -----------------------------------------------------------------------------
lambda-logs() {
  local function_name="$1"
  local minutes="${2:-10}"  # Default to last 10 minutes
  
  if [[ -z "$function_name" ]]; then
    if command -v fzf &>/dev/null; then
      echo "🔍 Fetching Lambda functions..."
      function_name=$(
        aws lambda list-functions \
          --query 'Functions[*].FunctionName' \
          --output text | tr '\t' '\n' | fzf --height 40% --prompt="Select Lambda function: "
      )
    else
      echo "Usage: lambda-logs <function-name> [minutes-ago]"
      return 1
    fi
  fi
  
  if [[ -n "$function_name" ]]; then
    echo "📜 Tailing logs for: $function_name (last $minutes minutes)"
    aws logs tail "/aws/lambda/$function_name" --since "${minutes}m" --follow
  fi
}

# -----------------------------------------------------------------------------
# aws-resources: List all resources in a region
# -----------------------------------------------------------------------------
#
# Provides a quick overview of resources across major AWS services.
# Useful for understanding what's deployed in an account/region.
#
# Usage:
#   aws-resources              # Current region
#   aws-resources us-east-1    # Specific region
#
# -----------------------------------------------------------------------------
aws-resources() {
  local region="${1:-$(aws configure get region)}"
  
  echo "🌐 AWS Resources in region: $region"
  echo "========================================="
  
  echo ""
  echo "💻 EC2 Instances"
  echo "---"
  aws ec2 describe-instances --region "$region" \
    --query 'Reservations[*].Instances[*].{ID:InstanceId,Name:Tags[?Key==`Name`]|[0].Value,State:State.Name}' \
    --output table 2>/dev/null || echo "None or no access"
  
  echo ""
  echo "📦 S3 Buckets"
  echo "---"
  aws s3 ls 2>/dev/null || echo "None or no access"
  
  echo ""
  echo "🗄️  RDS Instances"
  echo "---"
  aws rds describe-db-instances --region "$region" \
    --query 'DBInstances[*].{ID:DBInstanceIdentifier,Engine:Engine,Status:DBInstanceStatus}' \
    --output table 2>/dev/null || echo "None or no access"
  
  echo ""
  echo "☸️  EKS Clusters"
  echo "---"
  aws eks list-clusters --region "$region" --output table 2>/dev/null || echo "None or no access"
  
  echo ""
  echo "λ Lambda Functions"
  echo "---"
  aws lambda list-functions --region "$region" \
    --query 'Functions[*].{Name:FunctionName,Runtime:Runtime}' \
    --output table 2>/dev/null || echo "None or no access"
}

# -----------------------------------------------------------------------------
# aws-cost: Show last month's AWS costs by service
# -----------------------------------------------------------------------------
#
# Uses Cost Explorer API to show spending breakdown.
# Requires ce:GetCostAndUsage permission.
#
# Note: Cost Explorer data has 24-48 hour delay.
#
# Usage:
#   aws-cost
#
# -----------------------------------------------------------------------------
aws-cost() {
  # Calculate date range for last month
  local start_date=$(date -v-1m +%Y-%m-01 2>/dev/null || date -d '1 month ago' +%Y-%m-01)
  local end_date=$(date +%Y-%m-01)
  
  echo "💰 AWS Cost: $start_date to $end_date"
  echo "========================================="
  
  aws ce get-cost-and-usage \
    --time-period Start="$start_date",End="$end_date" \
    --granularity MONTHLY \
    --metrics "BlendedCost" \
    --group-by Type=DIMENSION,Key=SERVICE \
    --query 'ResultsByTime[*].Groups[*].{Service:Keys[0],Cost:Metrics.BlendedCost.Amount}' \
    --output table
}

# =============================================================================
# AWS VAULT INTEGRATION (Optional)
# =============================================================================
#
# aws-vault stores credentials securely in the OS keychain.
# These aliases only load if aws-vault is installed.
#
# Install: brew install aws-vault
#
# =============================================================================

if command -v aws-vault &>/dev/null; then
  alias av='aws-vault'                    # Base command
  alias ave='aws-vault exec'              # Execute command with credentials
  alias avl='aws-vault login'             # Open console in browser
  alias avls='aws-vault list'             # List profiles
  
  # -----------------------------------------------------------------------------
  # av-exec: Execute command with aws-vault credentials
  # -----------------------------------------------------------------------------
  #
  # Convenience wrapper that handles the common pattern of
  # executing commands with a specific profile.
  #
  # Usage:
  #   av-exec production terraform plan
  #   av-exec dev aws s3 ls
  #
  # -----------------------------------------------------------------------------
  av-exec() {
    local profile="$1"
    shift
    aws-vault exec "$profile" -- "$@"
  }
fi
