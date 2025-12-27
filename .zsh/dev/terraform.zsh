#!/usr/bin/env zsh
# ~/.zsh/dev/terraform.zsh - Terraform workflows and aliases
#
# Comprehensive Terraform tooling for infrastructure as code
#

# ====================================
# TERRAFORM ALIASES
# ====================================
if command -v terraform &>/dev/null; then
  alias tf='terraform'
  alias tfi='terraform init'
  alias tfp='terraform plan'
  alias tfa='terraform apply'
  alias tfd='terraform destroy'
  alias tfv='terraform validate'
  alias tff='terraform fmt -recursive'
  alias tfo='terraform output'
  alias tfs='terraform state'
  alias tfsl='terraform state list'
  alias tfss='terraform state show'
  alias tfw='terraform workspace'
  alias tfwl='terraform workspace list'
  alias tfws='terraform workspace select'
  alias tfwn='terraform workspace new'
  alias tfwd='terraform workspace delete'
  alias tfr='terraform refresh'
  alias tfg='terraform graph'
  alias tfc='terraform console'
  alias tfim='terraform import'
  alias tfta='terraform taint'
  alias tfun='terraform untaint'
  alias tflock='terraform providers lock'
fi

# ====================================
# TERRAFORM FUNCTIONS
# ====================================

# Initialize Terraform with backend config
tf-init-backend() {
  local env="${1:-dev}"
  local backend_config="backend-${env}.hcl"
  
  if [[ -f "$backend_config" ]]; then
    echo "Initializing Terraform with backend config: $backend_config"
    terraform init -backend-config="$backend_config" -reconfigure
  elif [[ -f "environments/${env}/backend.hcl" ]]; then
    echo "Initializing Terraform with backend config: environments/${env}/backend.hcl"
    terraform init -backend-config="environments/${env}/backend.hcl" -reconfigure
  else
    echo "No backend config found for environment: $env"
    echo "Looking for: $backend_config or environments/${env}/backend.hcl"
    return 1
  fi
}

# Plan with environment-specific tfvars
tf-plan-env() {
  local env="${1:-dev}"
  local var_file=""
  
  # Find the appropriate tfvars file
  if [[ -f "${env}.tfvars" ]]; then
    var_file="${env}.tfvars"
  elif [[ -f "environments/${env}/terraform.tfvars" ]]; then
    var_file="environments/${env}/terraform.tfvars"
  elif [[ -f "terraform.${env}.tfvars" ]]; then
    var_file="terraform.${env}.tfvars"
  fi
  
  if [[ -n "$var_file" ]]; then
    echo "Planning with var file: $var_file"
    terraform plan -var-file="$var_file" -out="tfplan-${env}"
  else
    echo "No tfvars file found for environment: $env"
    echo "Proceeding without var file..."
    terraform plan -out="tfplan-${env}"
  fi
}

# Apply with environment-specific tfvars
tf-apply-env() {
  local env="${1:-dev}"
  local plan_file="tfplan-${env}"
  
  if [[ -f "$plan_file" ]]; then
    echo "Applying plan file: $plan_file"
    terraform apply "$plan_file"
  else
    echo "No plan file found. Run tf-plan-env first."
    return 1
  fi
}

# Create new Terraform project structure
tf-project() {
  local project_name="$1"
  local provider="${2:-aws}"
  
  if [[ -z "$project_name" ]]; then
    echo "Usage: tf-project <project-name> [provider]"
    return 1
  fi
  
  mkdir -p "$project_name"/{modules,environments/{dev,staging,prod}}
  
  # Main configuration files
  cat > "$project_name/main.tf" << 'EOF'
# Main Terraform configuration

terraform {
  required_version = ">= 1.6.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  
  backend "s3" {}
}

provider "aws" {
  region = var.aws_region
  
  default_tags {
    tags = {
      Environment = var.environment
      Project     = var.project_name
      ManagedBy   = "Terraform"
    }
  }
}
EOF

  cat > "$project_name/variables.tf" << 'EOF'
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-west-2"
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "project_name" {
  description = "Project name"
  type        = string
}
EOF

  cat > "$project_name/outputs.tf" << 'EOF'
# Outputs
EOF

  # Environment-specific files
  for env in dev staging prod; do
    cat > "$project_name/environments/${env}/terraform.tfvars" << EOF
environment  = "${env}"
project_name = "${project_name}"
aws_region   = "us-west-2"
EOF

    cat > "$project_name/environments/${env}/backend.hcl" << EOF
bucket         = "terraform-state-${project_name}-${env}"
key            = "${project_name}/${env}/terraform.tfstate"
region         = "us-west-2"
encrypt        = true
dynamodb_table = "terraform-locks-${project_name}"
EOF
  done
  
  # README
  cat > "$project_name/README.md" << EOF
# ${project_name}

Terraform project for ${project_name}.

## Quick Start

\`\`\`bash
cd environments/dev
terraform init -backend-config=backend.hcl
terraform plan -var-file=terraform.tfvars
terraform apply -var-file=terraform.tfvars
\`\`\`
EOF

  # .gitignore
  cat > "$project_name/.gitignore" << 'EOF'
*.tfstate
*.tfstate.*
.terraform/
.terraform.lock.hcl
tfplan*
*.tfvars.json
crash.log
override.tf
override.tf.json
*_override.tf
*_override.tf.json
EOF

  echo "Created Terraform project: $project_name"
  echo "Structure:"
  find "$project_name" -type f | head -20
}

# Create a new Terraform module
tf-module() {
  local module_name="$1"
  local description="${2:-Terraform module}"
  
  if [[ -z "$module_name" ]]; then
    echo "Usage: tf-module <module-name> [description]"
    return 1
  fi
  
  local module_dir="modules/$module_name"
  mkdir -p "$module_dir"
  
  cat > "$module_dir/main.tf" << EOF
# ${description}

locals {
  common_tags = {
    Module = "${module_name}"
  }
}
EOF

  cat > "$module_dir/variables.tf" << 'EOF'
# Input variables
EOF

  cat > "$module_dir/outputs.tf" << 'EOF'
# Outputs
EOF

  cat > "$module_dir/versions.tf" << 'EOF'
terraform {
  required_version = ">= 1.6.0"
}
EOF

  cat > "$module_dir/README.md" << EOF
# ${module_name}

${description}

## Usage

\`\`\`hcl
module "${module_name}" {
  source = "./modules/${module_name}"
}
\`\`\`
EOF

  echo "Created module: $module_dir"
}

# Generate Terraform documentation
tf-docs() {
  local dir="${1:-.}"
  
  if command -v terraform-docs &>/dev/null; then
    terraform-docs markdown table "$dir" --output-file README.md
  else
    echo "terraform-docs not installed. Install with: brew install terraform-docs"
    return 1
  fi
}

# Run Terraform validation and security checks
tf-check() {
  echo "Running Terraform format check..."
  terraform fmt -check -recursive
  
  echo "\nRunning Terraform validate..."
  terraform validate
  
  if command -v tflint &>/dev/null; then
    echo "\nRunning TFLint..."
    tflint --recursive
  fi
  
  if command -v tfsec &>/dev/null; then
    echo "\nRunning tfsec..."
    tfsec .
  elif command -v trivy &>/dev/null; then
    echo "\nRunning Trivy..."
    trivy config .
  fi
  
  if command -v checkov &>/dev/null; then
    echo "\nRunning Checkov..."
    checkov -d .
  fi
}

# Estimate Terraform costs with Infracost
tf-cost() {
  local env="${1:-dev}"
  
  if ! command -v infracost &>/dev/null; then
    echo "Infracost not installed. Install with: brew install infracost"
    return 1
  fi
  
  local var_file=""
  if [[ -f "${env}.tfvars" ]]; then
    var_file="--terraform-var-file=${env}.tfvars"
  elif [[ -f "environments/${env}/terraform.tfvars" ]]; then
    var_file="--terraform-var-file=environments/${env}/terraform.tfvars"
  fi
  
  infracost breakdown --path . $var_file
}

# Export Terraform outputs to environment variables
tf-export() {
  local prefix="${1:-TF}"
  
  while IFS='=' read -r key value; do
    key=$(echo "$key" | tr '[:lower:]' '[:upper:]' | tr '-' '_')
    export "${prefix}_${key}=${value}"
    echo "Exported: ${prefix}_${key}"
  done < <(terraform output -json | jq -r 'to_entries[] | "\(.key)=\(.value.value)"')
}

# Switch Terraform workspace with confirmation
tf-switch() {
  local workspace="$1"
  
  if [[ -z "$workspace" ]]; then
    echo "Current workspace: $(terraform workspace show)"
    echo "Available workspaces:"
    terraform workspace list
    return 0
  fi
  
  echo "Switching to workspace: $workspace"
  terraform workspace select "$workspace" || terraform workspace new "$workspace"
}

# Show Terraform state in a readable format
tf-state-tree() {
  terraform state list | sed 's/\[/\n  [/g' | sort
}

# Destroy with double confirmation for safety
tf-destroy-safe() {
  local env="${1:-}"
  
  echo "⚠️  WARNING: This will destroy all resources!"
  echo "Environment: ${env:-default}"
  echo ""
  
  read -q "confirm?Type 'yes' to confirm destruction: "
  echo ""
  
  if [[ "$confirm" != "yes" ]]; then
    echo "Destruction cancelled."
    return 1
  fi
  
  read -q "double_confirm?Are you ABSOLUTELY sure? Type 'destroy' to proceed: "
  echo ""
  
  if [[ "$double_confirm" != "destroy" ]]; then
    echo "Destruction cancelled."
    return 1
  fi
  
  if [[ -n "$env" ]] && [[ -f "${env}.tfvars" ]]; then
    terraform destroy -var-file="${env}.tfvars"
  else
    terraform destroy
  fi
}
