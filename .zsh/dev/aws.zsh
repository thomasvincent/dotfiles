#!/usr/bin/env zsh
# ~/.zsh/dev/aws.zsh - AWS CLI workflows and aliases
#
# Comprehensive AWS tooling for cloud operations
#

# ====================================
# AWS ALIASES
# ====================================
if command -v aws &>/dev/null; then
  # General
  alias awsw='aws sts get-caller-identity'  # Who am I?
  alias awsr='aws configure list'            # Current config
  
  # EC2
  alias ec2ls='aws ec2 describe-instances --query "Reservations[*].Instances[*].{ID:InstanceId,Type:InstanceType,State:State.Name,Name:Tags[?Key==\`Name\`]|[0].Value,IP:PrivateIpAddress,PublicIP:PublicIpAddress}" --output table'
  alias ec2run='aws ec2 describe-instances --filters "Name=instance-state-name,Values=running" --query "Reservations[*].Instances[*].{ID:InstanceId,Name:Tags[?Key==\`Name\`]|[0].Value,Type:InstanceType,IP:PrivateIpAddress}" --output table'
  alias ec2stop='aws ec2 stop-instances --instance-ids'
  alias ec2start='aws ec2 start-instances --instance-ids'
  alias ec2ssh='aws ssm start-session --target'
  
  # S3
  alias s3ls='aws s3 ls'
  alias s3cp='aws s3 cp'
  alias s3sync='aws s3 sync'
  alias s3rm='aws s3 rm'
  alias s3mb='aws s3 mb'  # Make bucket
  alias s3rb='aws s3 rb'  # Remove bucket
  
  # ECS
  alias ecsls='aws ecs list-clusters --output table'
  alias ecssvc='aws ecs list-services --cluster'
  alias ecstasks='aws ecs list-tasks --cluster'
  
  # EKS
  alias eksls='aws eks list-clusters --output table'
  alias eksup='aws eks update-kubeconfig --name'
  
  # Lambda
  alias lambdals='aws lambda list-functions --query "Functions[*].{Name:FunctionName,Runtime:Runtime,Memory:MemorySize,Timeout:Timeout}" --output table'
  alias lambdalog='aws logs tail --follow'
  
  # RDS
  alias rdsls='aws rds describe-db-instances --query "DBInstances[*].{ID:DBInstanceIdentifier,Engine:Engine,Class:DBInstanceClass,Status:DBInstanceStatus}" --output table'
  
  # IAM
  alias iamls='aws iam list-users --query "Users[*].{Name:UserName,Created:CreateDate}" --output table'
  alias iamroles='aws iam list-roles --query "Roles[*].{Name:RoleName,Created:CreateDate}" --output table'
  
  # CloudFormation
  alias cfnls='aws cloudformation list-stacks --query "StackSummaries[?StackStatus!=\`DELETE_COMPLETE\`].{Name:StackName,Status:StackStatus}" --output table'
  alias cfnevents='aws cloudformation describe-stack-events --stack-name'
  
  # SSM
  alias ssmls='aws ssm describe-instance-information --query "InstanceInformationList[*].{ID:InstanceId,Name:ComputerName,Platform:PlatformType,Status:PingStatus}" --output table'
  alias ssmsh='aws ssm start-session --target'
  alias ssmcmd='aws ssm send-command'
  
  # Logs
  alias cwlogs='aws logs describe-log-groups --query "logGroups[*].logGroupName" --output table'
  alias cwtail='aws logs tail --follow'
fi

# ====================================
# AWS PROFILE MANAGEMENT
# ====================================

# List AWS profiles
aws-profiles() {
  echo "Available AWS Profiles:"
  grep '\[' ~/.aws/credentials 2>/dev/null | tr -d '[]'
  echo ""
  echo "Current profile: ${AWS_PROFILE:-default}"
}

# Switch AWS profile
aws-profile() {
  local profile="$1"
  
  if [[ -z "$profile" ]]; then
    if command -v fzf &>/dev/null; then
      profile=$(grep '\[' ~/.aws/credentials 2>/dev/null | tr -d '[]' | fzf --height 40% --prompt="Select AWS profile: ")
    else
      aws-profiles
      return 0
    fi
  fi
  
  if [[ -n "$profile" ]]; then
    export AWS_PROFILE="$profile"
    echo "Switched to AWS profile: $profile"
    aws sts get-caller-identity
  fi
}

# AWS SSO login
aws-sso-login() {
  local profile="${1:-$AWS_PROFILE}"
  if [[ -z "$profile" ]]; then
    echo "Usage: aws-sso-login <profile>" 
    echo "Or set AWS_PROFILE first"
    return 1
  fi
  
  echo "Logging into AWS SSO for profile: $profile"
  aws sso login --profile "$profile"
  export AWS_PROFILE="$profile"
}

# ====================================
# AWS FUNCTIONS
# ====================================

# Get EC2 instance by name tag
ec2-by-name() {
  local name="$1"
  if [[ -z "$name" ]]; then
    echo "Usage: ec2-by-name <instance-name-pattern>"
    return 1
  fi
  
  aws ec2 describe-instances \
    --filters "Name=tag:Name,Values=*${name}*" \
    --query 'Reservations[*].Instances[*].{ID:InstanceId,Name:Tags[?Key==`Name`]|[0].Value,State:State.Name,IP:PrivateIpAddress,Type:InstanceType}' \
    --output table
}

# SSH to EC2 via SSM
ec2-ssm() {
  local instance="$1"
  
  if [[ -z "$instance" ]]; then
    echo "Fetching running instances..."
    if command -v fzf &>/dev/null; then
      instance=$(aws ec2 describe-instances \
        --filters "Name=instance-state-name,Values=running" \
        --query 'Reservations[*].Instances[*].[InstanceId,Tags[?Key==`Name`]|[0].Value]' \
        --output text | fzf --height 40% --prompt="Select instance: " | awk '{print $1}')
    else
      aws ec2 describe-instances \
        --filters "Name=instance-state-name,Values=running" \
        --query 'Reservations[*].Instances[*].{ID:InstanceId,Name:Tags[?Key==`Name`]|[0].Value}' \
        --output table
      return 0
    fi
  fi
  
  if [[ -n "$instance" ]]; then
    echo "Connecting to: $instance"
    aws ssm start-session --target "$instance"
  fi
}

# S3 bucket size
s3-size() {
  local bucket="$1"
  if [[ -z "$bucket" ]]; then
    echo "Usage: s3-size <bucket-name>"
    return 1
  fi
  
  aws s3 ls "s3://$bucket" --recursive --summarize --human-readable | tail -2
}

# Get CloudWatch logs
cw-logs() {
  local log_group="$1"
  local minutes="${2:-30}"
  
  if [[ -z "$log_group" ]]; then
    if command -v fzf &>/dev/null; then
      log_group=$(aws logs describe-log-groups --query 'logGroups[*].logGroupName' --output text | tr '\t' '\n' | fzf --height 40% --prompt="Select log group: ")
    else
      echo "Usage: cw-logs <log-group-name> [minutes-ago]"
      return 1
    fi
  fi
  
  if [[ -n "$log_group" ]]; then
    echo "Tailing logs from: $log_group (last $minutes minutes)"
    aws logs tail "$log_group" --since "${minutes}m" --follow
  fi
}

# EKS cluster kubeconfig
eks-config() {
  local cluster="$1"
  local region="${2:-us-west-2}"
  
  if [[ -z "$cluster" ]]; then
    if command -v fzf &>/dev/null; then
      cluster=$(aws eks list-clusters --query 'clusters[*]' --output text | tr '\t' '\n' | fzf --height 40% --prompt="Select EKS cluster: ")
    else
      echo "Available clusters:"
      aws eks list-clusters --output table
      return 0
    fi
  fi
  
  if [[ -n "$cluster" ]]; then
    echo "Updating kubeconfig for cluster: $cluster"
    aws eks update-kubeconfig --name "$cluster" --region "$region"
  fi
}

# Get Lambda function logs
lambda-logs() {
  local function_name="$1"
  local minutes="${2:-10}"
  
  if [[ -z "$function_name" ]]; then
    if command -v fzf &>/dev/null; then
      function_name=$(aws lambda list-functions --query 'Functions[*].FunctionName' --output text | tr '\t' '\n' | fzf --height 40% --prompt="Select Lambda function: ")
    else
      echo "Usage: lambda-logs <function-name> [minutes-ago]"
      return 1
    fi
  fi
  
  if [[ -n "$function_name" ]]; then
    echo "Tailing logs for: $function_name"
    aws logs tail "/aws/lambda/$function_name" --since "${minutes}m" --follow
  fi
}

# List all resources in a region
aws-resources() {
  local region="${1:-$(aws configure get region)}"
  
  echo "AWS Resources in region: $region"
  echo "============================="
  
  echo "\n--- EC2 Instances ---"
  aws ec2 describe-instances --region "$region" \
    --query 'Reservations[*].Instances[*].{ID:InstanceId,Name:Tags[?Key==`Name`]|[0].Value,State:State.Name}' \
    --output table 2>/dev/null || echo "None or no access"
  
  echo "\n--- S3 Buckets ---"
  aws s3 ls 2>/dev/null || echo "None or no access"
  
  echo "\n--- RDS Instances ---"
  aws rds describe-db-instances --region "$region" \
    --query 'DBInstances[*].{ID:DBInstanceIdentifier,Engine:Engine,Status:DBInstanceStatus}' \
    --output table 2>/dev/null || echo "None or no access"
  
  echo "\n--- EKS Clusters ---"
  aws eks list-clusters --region "$region" --output table 2>/dev/null || echo "None or no access"
  
  echo "\n--- Lambda Functions ---"
  aws lambda list-functions --region "$region" \
    --query 'Functions[*].{Name:FunctionName,Runtime:Runtime}' \
    --output table 2>/dev/null || echo "None or no access"
}

# Cost explorer - last month
aws-cost() {
  local start_date=$(date -v-1m +%Y-%m-01)
  local end_date=$(date +%Y-%m-01)
  
  echo "AWS Cost: $start_date to $end_date"
  aws ce get-cost-and-usage \
    --time-period Start="$start_date",End="$end_date" \
    --granularity MONTHLY \
    --metrics "BlendedCost" \
    --group-by Type=DIMENSION,Key=SERVICE \
    --query 'ResultsByTime[*].Groups[*].{Service:Keys[0],Cost:Metrics.BlendedCost.Amount}' \
    --output table
}

# AWS Vault helper (if using aws-vault)
if command -v aws-vault &>/dev/null; then
  alias av='aws-vault'
  alias ave='aws-vault exec'
  alias avl='aws-vault login'
  alias avls='aws-vault list'
  
  av-exec() {
    local profile="$1"
    shift
    aws-vault exec "$profile" -- "$@"
  }
fi
