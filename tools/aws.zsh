#!/usr/bin/env zsh

# aws.zsh
# Author: Thomas Vincent
# GitHub: https://github.com/thomasvincent/dotfiles
#
# This file contains AWS-specific configuration.

# AWS CLI configuration
export AWS_PAGER=""  # Disable pager for AWS CLI output

# AWS CLI aliases
alias awsls="aws ec2 describe-instances --query 'Reservations[].Instances[].[InstanceId, State.Name, InstanceType, PublicIpAddress, Tags[?Key==\`Name\`].Value | [0]]' --output table"
alias awslb="aws elb describe-load-balancers --query 'LoadBalancerDescriptions[].[LoadBalancerName, DNSName]' --output table"
alias awss3="aws s3 ls"
alias awss3ls="aws s3 ls s3://"
alias awsrds="aws rds describe-db-instances --query 'DBInstances[].[DBInstanceIdentifier, Engine, DBInstanceStatus, Endpoint.Address]' --output table"
alias awssg="aws ec2 describe-security-groups --query 'SecurityGroups[].[GroupId, GroupName, Description]' --output table"
alias awsvpc="aws ec2 describe-vpcs --query 'Vpcs[].[VpcId, CidrBlock, Tags[?Key==\`Name\`].Value | [0]]' --output table"
alias awssub="aws ec2 describe-subnets --query 'Subnets[].[SubnetId, VpcId, CidrBlock, AvailabilityZone, Tags[?Key==\`Name\`].Value | [0]]' --output table"
alias awsiam="aws iam list-users --query 'Users[].[UserName, Arn, CreateDate]' --output table"
alias awsrole="aws iam list-roles --query 'Roles[].[RoleName, Arn, CreateDate]' --output table"
alias awsregion="aws ec2 describe-regions --query 'Regions[].[RegionName]' --output table"
alias awsaz="aws ec2 describe-availability-zones --query 'AvailabilityZones[].[ZoneName, State]' --output table"
alias awsami="aws ec2 describe-images --owners self --query 'Images[].[ImageId, Name, CreationDate]' --output table"
alias awsssm="aws ssm get-parameters-by-path --path / --recursive --query 'Parameters[].[Name, Value]' --output table"
alias awsecr="aws ecr describe-repositories --query 'repositories[].[repositoryName, repositoryUri]' --output table"
alias awsecs="aws ecs list-clusters --query 'clusterArns[]' --output table"
alias awslambda="aws lambda list-functions --query 'Functions[].[FunctionName, Runtime, Timeout, MemorySize]' --output table"
alias awscf="aws cloudformation list-stacks --query 'StackSummaries[].[StackName, StackStatus, CreationTime]' --output table"

# AWS profile management
aws-profile() {
  if [ $# -eq 0 ]; then
    echo "Current AWS profile: $AWS_PROFILE"
    return
  fi
  
  export AWS_PROFILE="$1"
  echo "AWS profile set to: $AWS_PROFILE"
}

# AWS region management
aws-region() {
  if [ $# -eq 0 ]; then
    echo "Current AWS region: $AWS_REGION"
    return
  fi
  
  export AWS_REGION="$1"
  export AWS_DEFAULT_REGION="$1"
  echo "AWS region set to: $AWS_REGION"
}

# AWS SSM session
aws-ssm() {
  if [ $# -eq 0 ]; then
    echo "Usage: aws-ssm <instance-id>"
    return 1
  fi
  
  aws ssm start-session --target "$1"
}

# AWS EC2 SSH
aws-ssh() {
  if [ $# -lt 1 ]; then
    echo "Usage: aws-ssh <instance-id> [user]"
    return 1
  fi
  
  local instance_id="$1"
  local user="${2:-ec2-user}"
  local ip=$(aws ec2 describe-instances --instance-ids "$instance_id" --query 'Reservations[0].Instances[0].PublicIpAddress' --output text)
  
  if [ -z "$ip" ] || [ "$ip" = "None" ]; then
    echo "No public IP found for instance $instance_id"
    return 1
  fi
  
  ssh "$user@$ip"
}

# AWS EC2 instance information
aws-instance-info() {
  if [ $# -eq 0 ]; then
    echo "Usage: aws-instance-info <instance-id>"
    return 1
  fi
  
  aws ec2 describe-instances --instance-ids "$1" --output table
}

# AWS S3 bucket size
aws-s3-size() {
  if [ $# -eq 0 ]; then
    echo "Usage: aws-s3-size <bucket-name>"
    return 1
  fi
  
  aws s3 ls s3://"$1" --recursive --human-readable --summarize | grep "Total Size"
}

# AWS CloudWatch logs
aws-logs() {
  if [ $# -lt 2 ]; then
    echo "Usage: aws-logs <log-group> <log-stream> [start-time]"
    return 1
  fi
  
  local log_group="$1"
  local log_stream="$2"
  local start_time="${3:-1h}"
  
  aws logs get-log-events --log-group-name "$log_group" --log-stream-name "$log_stream" --start-time "$(date -v-"$start_time" +%s)000" --output text
}

# AWS CloudFormation stack events
aws-stack-events() {
  if [ $# -eq 0 ]; then
    echo "Usage: aws-stack-events <stack-name>"
    return 1
  fi
  
  aws cloudformation describe-stack-events --stack-name "$1" --query 'StackEvents[].[Timestamp, LogicalResourceId, ResourceStatus, ResourceStatusReason]' --output table
}

# AWS CloudFormation stack resources
aws-stack-resources() {
  if [ $# -eq 0 ]; then
    echo "Usage: aws-stack-resources <stack-name>"
    return 1
  fi
  
  aws cloudformation describe-stack-resources --stack-name "$1" --query 'StackResources[].[LogicalResourceId, ResourceType, ResourceStatus]' --output table
}

# AWS CloudFormation stack outputs
aws-stack-outputs() {
  if [ $# -eq 0 ]; then
    echo "Usage: aws-stack-outputs <stack-name>"
    return 1
  fi
  
  aws cloudformation describe-stacks --stack-name "$1" --query 'Stacks[0].Outputs[].[OutputKey, OutputValue, Description]' --output table
}

# AWS CloudFormation stack parameters
aws-stack-parameters() {
  if [ $# -eq 0 ]; then
    echo "Usage: aws-stack-parameters <stack-name>"
    return 1
  fi
  
  aws cloudformation describe-stacks --stack-name "$1" --query 'Stacks[0].Parameters[].[ParameterKey, ParameterValue]' --output table
}

# AWS CloudFormation validate template
aws-validate-template() {
  if [ $# -eq 0 ]; then
    echo "Usage: aws-validate-template <template-file>"
    return 1
  fi
  
  aws cloudformation validate-template --template-body "file://$1"
}

# AWS CloudFormation create stack
aws-create-stack() {
  if [ $# -lt 2 ]; then
    echo "Usage: aws-create-stack <stack-name> <template-file> [parameters-file]"
    return 1
  fi
  
  local stack_name="$1"
  local template_file="$2"
  local parameters_file="${3:-}"
  
  if [ -n "$parameters_file" ]; then
    aws cloudformation create-stack --stack-name "$stack_name" --template-body "file://$template_file" --parameters "file://$parameters_file" --capabilities CAPABILITY_IAM CAPABILITY_NAMED_IAM
  else
    aws cloudformation create-stack --stack-name "$stack_name" --template-body "file://$template_file" --capabilities CAPABILITY_IAM CAPABILITY_NAMED_IAM
  fi
}

# AWS CloudFormation update stack
aws-update-stack() {
  if [ $# -lt 2 ]; then
    echo "Usage: aws-update-stack <stack-name> <template-file> [parameters-file]"
    return 1
  fi
  
  local stack_name="$1"
  local template_file="$2"
  local parameters_file="${3:-}"
  
  if [ -n "$parameters_file" ]; then
    aws cloudformation update-stack --stack-name "$stack_name" --template-body "file://$template_file" --parameters "file://$parameters_file" --capabilities CAPABILITY_IAM CAPABILITY_NAMED_IAM
  else
    aws cloudformation update-stack --stack-name "$stack_name" --template-body "file://$template_file" --capabilities CAPABILITY_IAM CAPABILITY_NAMED_IAM
  fi
}

# AWS CloudFormation delete stack
aws-delete-stack() {
  if [ $# -eq 0 ]; then
    echo "Usage: aws-delete-stack <stack-name>"
    return 1
  fi
  
  aws cloudformation delete-stack --stack-name "$1"
}

# AWS CloudFormation wait for stack
aws-wait-stack() {
  if [ $# -lt 2 ]; then
    echo "Usage: aws-wait-stack <stack-name> <status>"
    echo "Status: create-complete, update-complete, delete-complete"
    return 1
  fi
  
  aws cloudformation wait stack-"$2" --stack-name "$1"
}

# AWS EC2 start instance
aws-start-instance() {
  if [ $# -eq 0 ]; then
    echo "Usage: aws-start-instance <instance-id>"
    return 1
  fi
  
  aws ec2 start-instances --instance-ids "$1"
}

# AWS EC2 stop instance
aws-stop-instance() {
  if [ $# -eq 0 ]; then
    echo "Usage: aws-stop-instance <instance-id>"
    return 1
  fi
  
  aws ec2 stop-instances --instance-ids "$1"
}

# AWS EC2 reboot instance
aws-reboot-instance() {
  if [ $# -eq 0 ]; then
    echo "Usage: aws-reboot-instance <instance-id>"
    return 1
  fi
  
  aws ec2 reboot-instances --instance-ids "$1"
}

# AWS EC2 terminate instance
aws-terminate-instance() {
  if [ $# -eq 0 ]; then
    echo "Usage: aws-terminate-instance <instance-id>"
    return 1
  fi
  
  aws ec2 terminate-instances --instance-ids "$1"
}

# AWS EC2 get instance state
aws-instance-state() {
  if [ $# -eq 0 ]; then
    echo "Usage: aws-instance-state <instance-id>"
    return 1
  fi
  
  aws ec2 describe-instances --instance-ids "$1" --query 'Reservations[0].Instances[0].State.Name' --output text
}

# AWS EC2 get instance public IP
aws-instance-ip() {
  if [ $# -eq 0 ]; then
    echo "Usage: aws-instance-ip <instance-id>"
    return 1
  fi
  
  aws ec2 describe-instances --instance-ids "$1" --query 'Reservations[0].Instances[0].PublicIpAddress' --output text
}

# AWS EC2 get instance private IP
aws-instance-private-ip() {
  if [ $# -eq 0 ]; then
    echo "Usage: aws-instance-private-ip <instance-id>"
    return 1
  fi
  
  aws ec2 describe-instances --instance-ids "$1" --query 'Reservations[0].Instances[0].PrivateIpAddress' --output text
}

# AWS EC2 get instance type
aws-instance-type() {
  if [ $# -eq 0 ]; then
    echo "Usage: aws-instance-type <instance-id>"
    return 1
  fi
  
  aws ec2 describe-instances --instance-ids "$1" --query 'Reservations[0].Instances[0].InstanceType' --output text
}

# AWS EC2 get instance name
aws-instance-name() {
  if [ $# -eq 0 ]; then
    echo "Usage: aws-instance-name <instance-id>"
    return 1
  fi
  
  aws ec2 describe-instances --instance-ids "$1" --query 'Reservations[0].Instances[0].Tags[?Key==`Name`].Value | [0]' --output text
}

# AWS EC2 get instance security groups
aws-instance-sg() {
  if [ $# -eq 0 ]; then
    echo "Usage: aws-instance-sg <instance-id>"
    return 1
  fi
  
  aws ec2 describe-instances --instance-ids "$1" --query 'Reservations[0].Instances[0].SecurityGroups[].[GroupId, GroupName]' --output table
}

# AWS EC2 get instance subnet
aws-instance-subnet() {
  if [ $# -eq 0 ]; then
    echo "Usage: aws-instance-subnet <instance-id>"
    return 1
  fi
  
  aws ec2 describe-instances --instance-ids "$1" --query 'Reservations[0].Instances[0].SubnetId' --output text
}

# AWS EC2 get instance VPC
aws-instance-vpc() {
  if [ $# -eq 0 ]; then
    echo "Usage: aws-instance-vpc <instance-id>"
    return 1
  fi
  
  aws ec2 describe-instances --instance-ids "$1" --query 'Reservations[0].Instances[0].VpcId' --output text
}

# AWS EC2 get instance AZ
aws-instance-az() {
  if [ $# -eq 0 ]; then
    echo "Usage: aws-instance-az <instance-id>"
    return 1
  fi
  
  aws ec2 describe-instances --instance-ids "$1" --query 'Reservations[0].Instances[0].Placement.AvailabilityZone' --output text
}

# AWS EC2 get instance launch time
aws-instance-launch-time() {
  if [ $# -eq 0 ]; then
    echo "Usage: aws-instance-launch-time <instance-id>"
    return 1
  fi
  
  aws ec2 describe-instances --instance-ids "$1" --query 'Reservations[0].Instances[0].LaunchTime' --output text
}

# AWS EC2 get instance tags
aws-instance-tags() {
  if [ $# -eq 0 ]; then
    echo "Usage: aws-instance-tags <instance-id>"
    return 1
  fi
  
  aws ec2 describe-instances --instance-ids "$1" --query 'Reservations[0].Instances[0].Tags[].[Key, Value]' --output table
}

# AWS EC2 get instance volumes
aws-instance-volumes() {
  if [ $# -eq 0 ]; then
    echo "Usage: aws-instance-volumes <instance-id>"
    return 1
  fi
  
  aws ec2 describe-instances --instance-ids "$1" --query 'Reservations[0].Instances[0].BlockDeviceMappings[].[DeviceName, Ebs.VolumeId]' --output table
}

# AWS EC2 get instance IAM role
aws-instance-role() {
  if [ $# -eq 0 ]; then
    echo "Usage: aws-instance-role <instance-id>"
    return 1
  fi
  
  aws ec2 describe-instances --instance-ids "$1" --query 'Reservations[0].Instances[0].IamInstanceProfile.Arn' --output text
}

# AWS EC2 get instance user data
aws-instance-userdata() {
  if [ $# -eq 0 ]; then
    echo "Usage: aws-instance-userdata <instance-id>"
    return 1
  fi
  
  aws ec2 describe-instance-attribute --instance-id "$1" --attribute userData --query 'UserData.Value' --output text | base64 --decode
}

# AWS EC2 get instance console output
aws-instance-console() {
  if [ $# -eq 0 ]; then
    echo "Usage: aws-instance-console <instance-id>"
    return 1
  fi
  
  aws ec2 get-console-output --instance-id "$1" --output text
}

# AWS EC2 get instance status
aws-instance-status() {
  if [ $# -eq 0 ]; then
    echo "Usage: aws-instance-status <instance-id>"
    return 1
  fi
  
  aws ec2 describe-instance-status --instance-ids "$1" --query 'InstanceStatuses[0].[InstanceStatus.Status, SystemStatus.Status]' --output text
}

# AWS EC2 get instance metadata
aws-instance-metadata() {
  curl -s http://169.254.169.254/latest/meta-data/
}

# AWS EC2 get instance identity document
aws-instance-identity() {
  curl -s http://169.254.169.254/latest/dynamic/instance-identity/document
}

# AWS EC2 get instance public hostname
aws-instance-public-hostname() {
  if [ $# -eq 0 ]; then
    echo "Usage: aws-instance-public-hostname <instance-id>"
    return 1
  fi
  
  aws ec2 describe-instances --instance-ids "$1" --query 'Reservations[0].Instances[0].PublicDnsName' --output text
}

# AWS EC2 get instance private hostname
aws-instance-private-hostname() {
  if [ $# -eq 0 ]; then
    echo "Usage: aws-instance-private-hostname <instance-id>"
    return 1
  fi
  
  aws ec2 describe-instances --instance-ids "$1" --query 'Reservations[0].Instances[0].PrivateDnsName' --output text
}

# AWS EC2 get instance key name
aws-instance-key() {
  if [ $# -eq 0 ]; then
    echo "Usage: aws-instance-key <instance-id>"
    return 1
  fi
  
  aws ec2 describe-instances --instance-ids "$1" --query 'Reservations[0].Instances[0].KeyName' --output text
}

# AWS EC2 get instance AMI
aws-instance-ami() {
  if [ $# -eq 0 ]; then
    echo "Usage: aws-instance-ami <instance-id>"
    return 1
  fi
  
  aws ec2 describe-instances --instance-ids "$1" --query 'Reservations[0].Instances[0].ImageId' --output text
}

# AWS EC2 get instance root device
aws-instance-root-device() {
  if [ $# -eq 0 ]; then
    echo "Usage: aws-instance-root-device <instance-id>"
    return 1
  fi
  
  aws ec2 describe-instances --instance-ids "$1" --query 'Reservations[0].Instances[0].RootDeviceName' --output text
}

# AWS EC2 get instance root device type
aws-instance-root-device-type() {
  if [ $# -eq 0 ]; then
    echo "Usage: aws-instance-root-device-type <instance-id>"
    return 1
  fi
  
  aws ec2 describe-instances --instance-ids "$1" --query 'Reservations[0].Instances[0].RootDeviceType' --output text
}

# AWS EC2 get instance architecture
aws-instance-architecture() {
  if [ $# -eq 0 ]; then
    echo "Usage: aws-instance-architecture <instance-id>"
    return 1
  fi
  
  aws ec2 describe-instances --instance-ids "$1" --query 'Reservations[0].Instances[0].Architecture' --output text
}

# AWS EC2 get instance hypervisor
aws-instance-hypervisor() {
  if [ $# -eq 0 ]; then
    echo "Usage: aws-instance-hypervisor <instance-id>"
    return 1
  fi
  
  aws ec2 describe-instances --instance-ids "$1" --query 'Reservations[0].Instances[0].Hypervisor' --output text
}

# AWS EC2 get instance virtualization type
aws-instance-virtualization() {
  if [ $# -eq 0 ]; then
    echo "Usage: aws-instance-virtualization <instance-id>"
    return 1
  fi
  
  aws ec2 describe-instances --instance-ids "$1" --query 'Reservations[0].Instances[0].VirtualizationType' --output text
}

# AWS EC2 get instance platform
aws-instance-platform() {
  if [ $# -eq 0 ]; then
    echo "Usage: aws-instance-platform <instance-id>"
    return 1
  fi
  
  aws ec2 describe-instances --instance-ids "$1" --query 'Reservations[0].Instances[0].Platform' --output text
}

# AWS EC2 get instance tenancy
aws-instance-tenancy() {
  if [ $# -eq 0 ]; then
    echo "Usage: aws-instance-tenancy <instance-id>"
    return 1
  fi
  
  aws ec2 describe-instances --instance-ids "$1" --query 'Reservations[0].Instances[0].Placement.Tenancy' --output text
}

# AWS EC2 get instance EBS optimization
aws-instance-ebs-optimization() {
  if [ $# -eq 0 ]; then
    echo "Usage: aws-instance-ebs-optimization <instance-id>"
    return 1
  fi
  
  aws ec2 describe-instances --instance-ids "$1" --query 'Reservations[0].Instances[0].EbsOptimized' --output text
}

# AWS EC2 get instance network interfaces
aws-instance-network-interfaces() {
  if [ $# -eq 0 ]; then
    echo "Usage: aws-instance-network-interfaces <instance-id>"
    return 1
  fi
  
  aws ec2 describe-instances --instance-ids "$1" --query 'Reservations[0].Instances[0].NetworkInterfaces[].[NetworkInterfaceId, PrivateIpAddress, SubnetId, VpcId]' --output table
}

# AWS EC2 get instance source dest check
aws-instance-source-dest-check() {
  if [ $# -eq 0 ]; then
    echo "Usage: aws-instance-source-dest-check <instance-id>"
    return 1
  fi
  
  aws ec2 describe-instances --instance-ids "$1" --query 'Reservations[0].Instances[0].SourceDestCheck' --output text
}

# AWS EC2 get instance monitoring
aws-instance-monitoring() {
  if [ $# -eq 0 ]; then
    echo "Usage: aws-instance-monitoring <instance-id>"
    return 1
  fi
  
  aws ec2 describe-instances --instance-ids "$1" --query 'Reservations[0].Instances[0].Monitoring.State' --output text
}

# AWS EC2 get instance termination protection
aws-instance-termination-protection() {
  if [ $# -eq 0 ]; then
    echo "Usage: aws-instance-termination-protection <instance-id>"
    return 1
  fi
  
  aws ec2 describe-instance-attribute --instance-id "$1" --attribute disableApiTermination --query 'DisableApiTermination.Value' --output text
}

# AWS EC2 enable termination protection
aws-enable-termination-protection() {
  if [ $# -eq 0 ]; then
    echo "Usage: aws-enable-termination-protection <instance-id>"
    return 1
  fi
  
  aws ec2 modify-instance-attribute --instance-id "$1" --disable-api-termination
}

# AWS EC2 disable termination protection
aws-disable-termination-protection() {
  if [ $# -eq 0 ]; then
    echo "Usage: aws-disable-termination-protection <instance-id>"
    return 1
  fi
  
  aws ec2 modify-instance-attribute --instance-id "$1" --no-disable-api-termination
}

# AWS EC2 enable detailed monitoring
aws-enable-detailed-monitoring() {
  if [ $# -eq 0 ]; then
    echo "Usage: aws-enable-detailed-monitoring <instance-id>"
    return 1
  fi
  
  aws ec2 monitor-instances --instance-ids "$1"
}

# AWS EC2 disable detailed monitoring
aws-disable-detailed-monitoring() {
  if [ $# -eq 0 ]; then
    echo "Usage: aws-disable-detailed-monitoring <instance-id>"
    return 1
  fi
  
  aws ec2 unmonitor-instances --instance-ids "$1"
}

# AWS EC2 enable source dest check
aws-enable-source-dest-check() {
  if [ $# -eq 0 ]; then
    echo "Usage: aws-enable-source-dest-check <instance-id>"
    return 1
  fi
  
  aws ec2 modify-instance-attribute --instance-id "$1" --source-dest-check "{\"Value\": true}"
}

# AWS EC2 disable source dest check
aws-disable-source-dest-check() {
  if [ $# -eq 0 ]; then
    echo "Usage: aws-disable-source-dest-check <instance-id>"
    return 1
  fi
  
  aws ec2 modify-instance-attribute --instance-id "$1" --source-dest-check "{\"Value\": false}"
}

# AWS EC2 modify instance type
aws-modify-instance-type() {
  if [ $# -lt 2 ]; then
    echo "Usage: aws-modify-instance-type <instance-id> <instance-type>"
    return 1
  fi
  
  aws ec2 modify-instance-attribute --instance-id "$1" --instance-type "{\"Value\": \"$2\"}"
}

# AWS EC2 modify instance user data
aws-modify-instance-userdata() {
  if [ $# -lt 2 ]; then
    echo "Usage: aws-modify-instance-userdata <instance-id> <userdata-file>"
    return 1
  fi
  
  aws ec2 modify-instance-attribute --instance-id "$1" --user-data "file://$2"
}

# AWS EC2 modify instance security groups
aws-modify-instance-sg() {
  if [ $# -lt 2 ]; then
    echo "Usage: aws-modify-instance-sg <instance-id> <security-group-id> [security-group-id...]"
    return 1
  fi
  
  local instance_id="$1"
  shift
  
  aws ec2 modify-instance-attribute --instance-id "$instance_id" --groups "$@"
}

# AWS EC2 modify instance IAM role
aws-modify-instance-role() {
  if [ $# -lt 2 ]; then
    echo "Usage: aws-modify-instance-role <instance-id> <role-name>"
    return 1
  fi
  
  aws ec2 associate-iam-instance-profile --instance-id "$1" --iam-instance-profile "Name=$2"
}

# AWS EC2 modify instance EBS optimization
aws-modify-instance-ebs-optimization() {
  if [ $# -lt 2 ]; then
    echo "Usage: aws-modify-instance-ebs-optimization <instance-id> <true|false>"
    return 1
  fi
  
  aws ec2 modify-instance-attribute --instance-id "$1" --ebs-optimized "{\"Value\": $2}"
}

# AWS EC2 create image
aws-create-image() {
  if [ $# -lt 2 ]; then
    echo "Usage: aws-create-image <instance-id> <image-name> [description]"
    return 1
  fi
  
  local instance_id="$1"
  local image_name="$2"
  local description="${3:-}"
  
  if [ -n "$description" ]; then
    aws ec2 create-image --instance-id "$instance_id" --name "$image_name" --description "$description" --no-reboot
  else
    aws ec2 create-image --instance-id "$instance_id" --name "$image_name" --no-reboot
  fi
}

# AWS EC2 create snapshot
aws-create-snapshot() {
  if [ $# -lt 2 ]; then
    echo "Usage: aws-create-snapshot <volume-id> <description>"
    return 1
  fi
  
  aws ec2 create-snapshot --volume-id "$1" --description "$2"
}

# AWS EC2 create volume
aws-create-volume() {
  if [ $# -lt 3 ]; then
    echo "Usage: aws-create-volume <availability-zone> <size> <volume-type> [iops]"
    return 1
  fi
  
  local az="$1"
  local size="$2"
  local volume_type="$3"
  local iops="${4:-}"
  
  if [ -n "$iops" ]; then
    aws ec2 create-volume --availability-zone "$az" --size "$size" --volume-type "$volume_type" --iops "$iops"
  else
    aws ec2 create-volume --availability-zone "$az" --size "$size" --volume-type "$volume_type"
  fi
}

# AWS EC2 attach volume
aws-attach-volume() {
  if [ $# -lt 3 ]; then
    echo "Usage: aws-attach-volume <volume-id> <instance-id> <device>"
    return 1
  fi
  
  aws ec2 attach-volume --volume-id "$1" --instance-id "$2" --device "$3"
}

# AWS EC2 detach volume
aws-detach-volume() {
  if [ $# -eq 0 ]; then
    echo "Usage: aws-detach-volume <volume-id>"
    return 1
  fi
  
  aws ec2 detach-volume --volume-id "$1"
}

# AWS EC2 delete volume
aws-delete-volume() {
  if [ $# -eq 0 ]; then
    echo "Usage: aws-delete-volume <volume-id>"
    return 1
  fi
  
  aws ec2 delete-volume --volume-id "$1"
}

# AWS EC2 delete snapshot
aws-delete-snapshot() {
  if [ $# -eq 0 ]; then
    echo "Usage: aws-delete-snapshot <snapshot-id>"
    return 1
  fi
  
  aws ec2 delete-snapshot --snapshot-id "$1"
}

# AWS EC2 delete image
aws-delete-image() {
  if [ $# -eq 0
