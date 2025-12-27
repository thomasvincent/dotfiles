#!/usr/bin/env zsh
# =============================================================================
# Terraform Workflows and Aliases
# =============================================================================
#
# File: ~/.zsh/dev/terraform.zsh
# Purpose: Comprehensive Terraform tooling for Infrastructure as Code
# Dependencies: terraform, terraform-docs (optional), tflint (optional),
#               tfsec (optional), infracost (optional)
#
# Usage:
#   Source this file in your .zshrc or through the dev/index.zsh loader.
#   All functions check for terraform availability before running.
#
# =============================================================================

# =============================================================================
# TERRAFORM ALIASES
# =============================================================================
#
# Short aliases for common terraform commands. These save keystrokes
# and make terraform workflows faster.
#
# Naming convention:
#   tf  = terraform (base)
#   tf* = terraform subcommands
#
# =============================================================================

if command -v terraform &>/dev/null; then
  # ---------------------------------------------------------------------------
  # Core Commands
  # ---------------------------------------------------------------------------
  alias tf='terraform'                    # Base command
  alias tfi='terraform init'              # Initialize working directory
  alias tfp='terraform plan'              # Show execution plan
  alias tfa='terraform apply'             # Apply changes
  alias tfd='terraform destroy'           # Destroy infrastructure
  alias tfv='terraform validate'          # Validate configuration
  alias tff='terraform fmt -recursive'    # Format all .tf files
  alias tfo='terraform output'            # Show output values
  alias tfr='terraform refresh'           # Refresh state
  alias tfc='terraform console'           # Interactive console
  
  # ---------------------------------------------------------------------------
  # State Management
  # ---------------------------------------------------------------------------
  alias tfs='terraform state'             # State commands
  alias tfsl='terraform state list'       # List resources in state
  alias tfss='terraform state show'       # Show resource in state
  alias tfim='terraform import'           # Import existing resource
  alias tfta='terraform taint'            # Mark resource for recreation
  alias tfun='terraform untaint'          # Remove taint from resource
  
  # ---------------------------------------------------------------------------
  # Workspace Management
  # ---------------------------------------------------------------------------
  # Workspaces allow you to manage multiple environments with the same config
  alias tfw='terraform workspace'         # Workspace commands
  alias tfwl='terraform workspace list'   # List workspaces
  alias tfws='terraform workspace select' # Select workspace
  alias tfwn='terraform workspace new'    # Create new workspace
  alias tfwd='terraform workspace delete' # Delete workspace
  
  # ---------------------------------------------------------------------------
  # Misc
  # ---------------------------------------------------------------------------
  alias tfg='terraform graph'             # Generate visual graph
  alias tflock='terraform providers lock' # Lock provider versions
fi

# =============================================================================
# TERRAFORM FUNCTIONS
# =============================================================================
#
# These functions provide higher-level workflows that combine multiple
# terraform commands or add convenience features like environment detection.
#
# =============================================================================

# -----------------------------------------------------------------------------
# tf-init-backend: Initialize Terraform with environment-specific backend
# -----------------------------------------------------------------------------
#
# Looks for backend config files in common locations:
#   1. backend-{env}.hcl in current directory
#   2. environments/{env}/backend.hcl
#
# Usage:
#   tf-init-backend dev      # Initialize with dev backend
#   tf-init-backend prod     # Initialize with prod backend
#
# -----------------------------------------------------------------------------
tf-init-backend() {
  local env="${1:-dev}"  # Default to 'dev' if no environment specified
  local backend_config="backend-${env}.hcl"
  
  # Try to find backend config in common locations
  if [[ -f "$backend_config" ]]; then
    echo "🚀 Initializing Terraform with backend config: $backend_config"
    terraform init -backend-config="$backend_config" -reconfigure
  elif [[ -f "environments/${env}/backend.hcl" ]]; then
    echo "🚀 Initializing Terraform with backend config: environments/${env}/backend.hcl"
    terraform init -backend-config="environments/${env}/backend.hcl" -reconfigure
  else
    echo "❌ No backend config found for environment: $env"
    echo "   Looked for: $backend_config"
    echo "   Looked for: environments/${env}/backend.hcl"
    return 1
  fi
}

# -----------------------------------------------------------------------------
# tf-plan-env: Plan with environment-specific tfvars
# -----------------------------------------------------------------------------
#
# Automatically finds and uses the right tfvars file for the environment.
# Saves the plan to a file for later apply.
#
# Usage:
#   tf-plan-env staging    # Plan for staging environment
#
# -----------------------------------------------------------------------------
tf-plan-env() {
  local env="${1:-dev}"
  local var_file=""
  
  # Search for tfvars file in common locations
  if [[ -f "${env}.tfvars" ]]; then
    var_file="${env}.tfvars"
  elif [[ -f "environments/${env}/terraform.tfvars" ]]; then
    var_file="environments/${env}/terraform.tfvars"
  elif [[ -f "terraform.${env}.tfvars" ]]; then
    var_file="terraform.${env}.tfvars"
  fi
  
  if [[ -n "$var_file" ]]; then
    echo "📋 Planning with var file: $var_file"
    terraform plan -var-file="$var_file" -out="tfplan-${env}"
    echo "
✅ Plan saved to: tfplan-${env}"
    echo "   Apply with: tf-apply-env ${env}"
  else
    echo "⚠️  No tfvars file found for environment: $env"
    echo "   Proceeding without var file..."
    terraform plan -out="tfplan-${env}"
  fi
}

# -----------------------------------------------------------------------------
# tf-apply-env: Apply a saved plan file
# -----------------------------------------------------------------------------
#
# Applies a plan that was previously saved by tf-plan-env.
# This ensures you apply exactly what you reviewed.
#
# Usage:
#   tf-apply-env staging   # Apply the staging plan
#
# -----------------------------------------------------------------------------
tf-apply-env() {
  local env="${1:-dev}"
  local plan_file="tfplan-${env}"
  
  if [[ -f "$plan_file" ]]; then
    echo "🚀 Applying plan file: $plan_file"
    terraform apply "$plan_file"
  else
    echo "❌ No plan file found: $plan_file"
    echo "   Run 'tf-plan-env ${env}' first to create a plan."
    return 1
  fi
}

# -----------------------------------------------------------------------------
# tf-project: Create a new Terraform project with best-practice structure
# -----------------------------------------------------------------------------
#
# Scaffolds a complete Terraform project with:
#   - Main config files (main.tf, variables.tf, outputs.tf)
#   - Environment-specific directories (dev, staging, prod)
#   - Backend configuration templates
#   - .gitignore for Terraform
#   - README with usage instructions
#
# Usage:
#   tf-project my-infrastructure aws    # Create AWS project
#   tf-project my-infra gcp              # Create GCP project
#
# -----------------------------------------------------------------------------
tf-project() {
  local project_name="$1"
  local provider="${2:-aws}"  # Default to AWS
  
  # Validate input
  if [[ -z "$project_name" ]]; then
    echo "Usage: tf-project <project-name> [provider]"
    echo "  provider: aws (default), gcp, azure"
    return 1
  fi
  
  echo "📁 Creating Terraform project: $project_name"
  
  # Create directory structure
  mkdir -p "$project_name"/{modules,environments/{dev,staging,prod}}
  
  # ---------------------------------------------------------------------------
  # Main Terraform configuration
  # ---------------------------------------------------------------------------
  cat > "$project_name/main.tf" << 'EOF'
# =============================================================================
# Main Terraform Configuration
# =============================================================================
#
# This is the entry point for the Terraform configuration.
# Provider configuration and backend settings are defined here.
#
# =============================================================================

terraform {
  # Minimum Terraform version required
  required_version = ">= 1.6.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  
  # Backend configuration is loaded from environment-specific .hcl files
  # Run: terraform init -backend-config=environments/{env}/backend.hcl
  backend "s3" {}
}

# -----------------------------------------------------------------------------
# AWS Provider Configuration
# -----------------------------------------------------------------------------
# Default tags are applied to all resources for cost tracking and management.
# -----------------------------------------------------------------------------
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

  # ---------------------------------------------------------------------------
  # Variables file
  # ---------------------------------------------------------------------------
  cat > "$project_name/variables.tf" << 'EOF'
# =============================================================================
# Input Variables
# =============================================================================
#
# Define all input variables here. Use descriptive names and always include
# a description. Set sensible defaults where appropriate.
#
# =============================================================================

variable "aws_region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "us-west-2"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod."
  }
}

variable "project_name" {
  description = "Name of the project for tagging and naming resources"
  type        = string
}
EOF

  # ---------------------------------------------------------------------------
  # Outputs file
  # ---------------------------------------------------------------------------
  cat > "$project_name/outputs.tf" << 'EOF'
# =============================================================================
# Outputs
# =============================================================================
#
# Define outputs for values that other configurations might need,
# or that you want to easily retrieve after apply.
#
# =============================================================================

# Example output:
# output "vpc_id" {
#   description = "ID of the created VPC"
#   value       = module.vpc.vpc_id
# }
EOF

  # ---------------------------------------------------------------------------
  # Environment-specific configuration
  # ---------------------------------------------------------------------------
  for env in dev staging prod; do
    # tfvars for each environment
    cat > "$project_name/environments/${env}/terraform.tfvars" << EOF
# =============================================================================
# ${env} Environment Variables
# =============================================================================

environment  = "${env}"
project_name = "${project_name}"
aws_region   = "us-west-2"
EOF

    # Backend config for each environment
    cat > "$project_name/environments/${env}/backend.hcl" << EOF
# =============================================================================
# ${env} Backend Configuration
# =============================================================================
#
# S3 backend with DynamoDB locking for state management.
# Initialize with: terraform init -backend-config=environments/${env}/backend.hcl
#
# =============================================================================

bucket         = "terraform-state-${project_name}-${env}"
key            = "${project_name}/${env}/terraform.tfstate"
region         = "us-west-2"
encrypt        = true
dynamodb_table = "terraform-locks-${project_name}"
EOF
  done
  
  # ---------------------------------------------------------------------------
  # README
  # ---------------------------------------------------------------------------
  cat > "$project_name/README.md" << EOF
# ${project_name}

Terraform project for ${project_name}.

## Quick Start

\`\`\`bash
# Initialize for dev environment
cd ${project_name}
terraform init -backend-config=environments/dev/backend.hcl

# Plan changes
terraform plan -var-file=environments/dev/terraform.tfvars

# Apply changes
terraform apply -var-file=environments/dev/terraform.tfvars
\`\`\`

## Structure

\`\`\`
${project_name}/
├── main.tf              # Provider and backend configuration
├── variables.tf         # Input variable definitions
├── outputs.tf           # Output definitions
├── modules/             # Reusable Terraform modules
└── environments/
    ├── dev/             # Development environment
    ├── staging/         # Staging environment
    └── prod/            # Production environment
\`\`\`
EOF

  # ---------------------------------------------------------------------------
  # .gitignore
  # ---------------------------------------------------------------------------
  cat > "$project_name/.gitignore" << 'EOF'
# Terraform state (managed by backend)
*.tfstate
*.tfstate.*
.terraform/
.terraform.lock.hcl

# Plan files
tfplan*

# Sensitive variable files
*.tfvars.json
*-secrets.tfvars

# Crash logs
crash.log
crash.*.log

# Override files
override.tf
override.tf.json
*_override.tf
*_override.tf.json
EOF

  echo "✅ Created Terraform project: $project_name"
  echo ""
  echo "Next steps:"
  echo "  cd $project_name"
  echo "  terraform init -backend-config=environments/dev/backend.hcl"
}

# -----------------------------------------------------------------------------
# tf-module: Create a new Terraform module
# -----------------------------------------------------------------------------
#
# Creates a reusable module with standard structure.
#
# Usage:
#   tf-module vpc "VPC and networking"    # Create VPC module
#
# -----------------------------------------------------------------------------
tf-module() {
  local module_name="$1"
  local description="${2:-Terraform module}"
  
  if [[ -z "$module_name" ]]; then
    echo "Usage: tf-module <module-name> [description]"
    return 1
  fi
  
  local module_dir="modules/$module_name"
  echo "📦 Creating module: $module_dir"
  
  mkdir -p "$module_dir"
  
  # Main module file
  cat > "$module_dir/main.tf" << EOF
# =============================================================================
# ${module_name} Module
# =============================================================================
#
# ${description}
#
# =============================================================================

locals {
  # Common tags to apply to all resources in this module
  common_tags = {
    Module = "${module_name}"
  }
}

# Add your resources here
EOF

  # Variables
  cat > "$module_dir/variables.tf" << 'EOF'
# =============================================================================
# Module Input Variables
# =============================================================================

# Add your input variables here
# Example:
# variable "name" {
#   description = "Name for the resource"
#   type        = string
# }
EOF

  # Outputs
  cat > "$module_dir/outputs.tf" << 'EOF'
# =============================================================================
# Module Outputs
# =============================================================================

# Add your outputs here
# Example:
# output "id" {
#   description = "ID of the created resource"
#   value       = aws_resource.main.id
# }
EOF

  # Versions
  cat > "$module_dir/versions.tf" << 'EOF'
# =============================================================================
# Provider Version Constraints
# =============================================================================

terraform {
  required_version = ">= 1.6.0"
}
EOF

  # README
  cat > "$module_dir/README.md" << EOF
# ${module_name}

${description}

## Usage

\`\`\`hcl
module "${module_name}" {
  source = "./modules/${module_name}"
  
  # Add required variables here
}
\`\`\`

## Inputs

| Name | Description | Type | Required |
|------|-------------|------|----------|
| TBD | TBD | TBD | TBD |

## Outputs

| Name | Description |
|------|-------------|
| TBD | TBD |
EOF

  echo "✅ Created module: $module_dir"
}

# -----------------------------------------------------------------------------
# tf-docs: Generate Terraform documentation
# -----------------------------------------------------------------------------
#
# Uses terraform-docs to generate markdown documentation from your code.
# Install: brew install terraform-docs
#
# Usage:
#   tf-docs           # Generate for current directory
#   tf-docs modules/  # Generate for modules directory
#
# -----------------------------------------------------------------------------
tf-docs() {
  local dir="${1:-.}"
  
  if command -v terraform-docs &>/dev/null; then
    echo "📝 Generating documentation for: $dir"
    terraform-docs markdown table "$dir" --output-file README.md
    echo "✅ Documentation written to: $dir/README.md"
  else
    echo "❌ terraform-docs not installed"
    echo "   Install with: brew install terraform-docs"
    return 1
  fi
}

# -----------------------------------------------------------------------------
# tf-check: Run validation and security checks
# -----------------------------------------------------------------------------
#
# Runs multiple tools to validate your Terraform code:
#   - terraform fmt -check: Check formatting
#   - terraform validate: Check syntax and configuration
#   - tflint: Lint for best practices
#   - tfsec/trivy: Security scanning
#   - checkov: Policy as code
#
# Usage:
#   tf-check    # Run all checks
#
# -----------------------------------------------------------------------------
tf-check() {
  local exit_code=0
  
  echo "🔍 Running Terraform checks..."
  echo ""
  
  # Format check
  echo "1️⃣  Checking formatting..."
  if terraform fmt -check -recursive; then
    echo "   ✓ Formatting OK"
  else
    echo "   ✗ Formatting issues found. Run: terraform fmt -recursive"
    exit_code=1
  fi
  echo ""
  
  # Validate
  echo "2️⃣  Validating configuration..."
  if terraform validate; then
    echo "   ✓ Validation OK"
  else
    echo "   ✗ Validation failed"
    exit_code=1
  fi
  echo ""
  
  # TFLint (if installed)
  if command -v tflint &>/dev/null; then
    echo "3️⃣  Running TFLint..."
    if tflint --recursive; then
      echo "   ✓ TFLint OK"
    else
      echo "   ✗ TFLint found issues"
      exit_code=1
    fi
    echo ""
  fi
  
  # Security scanning (tfsec or trivy)
  if command -v tfsec &>/dev/null; then
    echo "4️⃣  Running tfsec security scan..."
    tfsec . || exit_code=1
    echo ""
  elif command -v trivy &>/dev/null; then
    echo "4️⃣  Running Trivy security scan..."
    trivy config . || exit_code=1
    echo ""
  fi
  
  # Checkov (if installed)
  if command -v checkov &>/dev/null; then
    echo "5️⃣  Running Checkov policy scan..."
    checkov -d . || exit_code=1
    echo ""
  fi
  
  # Summary
  if [[ $exit_code -eq 0 ]]; then
    echo "✅ All checks passed!"
  else
    echo "❌ Some checks failed. Please fix the issues above."
  fi
  
  return $exit_code
}

# -----------------------------------------------------------------------------
# tf-cost: Estimate infrastructure costs
# -----------------------------------------------------------------------------
#
# Uses Infracost to estimate the cost of your infrastructure.
# Install: brew install infracost && infracost auth login
#
# Usage:
#   tf-cost           # Estimate for current config
#   tf-cost prod      # Estimate with prod.tfvars
#
# -----------------------------------------------------------------------------
tf-cost() {
  local env="${1:-}"
  
  if ! command -v infracost &>/dev/null; then
    echo "❌ Infracost not installed"
    echo "   Install with: brew install infracost"
    echo "   Then run: infracost auth login"
    return 1
  fi
  
  local var_file=""
  if [[ -n "$env" ]]; then
    if [[ -f "${env}.tfvars" ]]; then
      var_file="--terraform-var-file=${env}.tfvars"
    elif [[ -f "environments/${env}/terraform.tfvars" ]]; then
      var_file="--terraform-var-file=environments/${env}/terraform.tfvars"
    fi
  fi
  
  echo "💰 Estimating infrastructure costs..."
  infracost breakdown --path . $var_file
}

# -----------------------------------------------------------------------------
# tf-export: Export Terraform outputs to environment variables
# -----------------------------------------------------------------------------
#
# Useful for using Terraform outputs in shell scripts or other tools.
#
# Usage:
#   tf-export        # Export with TF_ prefix
#   tf-export AWS    # Export with AWS_ prefix
#
# -----------------------------------------------------------------------------
tf-export() {
  local prefix="${1:-TF}"
  
  echo "📤 Exporting Terraform outputs with prefix: ${prefix}_"
  
  while IFS='=' read -r key value; do
    # Convert key to uppercase and replace hyphens with underscores
    key=$(echo "$key" | tr '[:lower:]' '[:upper:]' | tr '-' '_')
    export "${prefix}_${key}=${value}"
    echo "   ${prefix}_${key}=${value}"
  done < <(terraform output -json | jq -r 'to_entries[] | "\(.key)=\(.value.value)"')
  
  echo "✅ Outputs exported"
}

# -----------------------------------------------------------------------------
# tf-destroy-safe: Destroy with double confirmation
# -----------------------------------------------------------------------------
#
# Extra safety for destroy operations. Requires typing "yes" then "destroy".
# Use this instead of raw terraform destroy in production.
#
# Usage:
#   tf-destroy-safe prod    # Destroy prod with confirmation
#
# -----------------------------------------------------------------------------
tf-destroy-safe() {
  local env="${1:-}"
  
  echo ""
  echo "⚠️  ⚠️  ⚠️  WARNING: DESTRUCTIVE OPERATION ⚠️  ⚠️  ⚠️"
  echo ""
  echo "This will DESTROY all resources managed by this Terraform configuration."
  echo "Environment: ${env:-default}"
  echo "Directory: $(pwd)"
  echo ""
  
  # First confirmation
  echo -n "Type 'yes' to confirm you want to destroy: "
  read confirm
  
  if [[ "$confirm" != "yes" ]]; then
    echo "❌ Destruction cancelled."
    return 1
  fi
  
  # Second confirmation
  echo ""
  echo -n "Are you ABSOLUTELY sure? Type 'destroy' to proceed: "
  read double_confirm
  
  if [[ "$double_confirm" != "destroy" ]]; then
    echo "❌ Destruction cancelled."
    return 1
  fi
  
  echo ""
  echo "💥 Proceeding with destroy..."
  
  if [[ -n "$env" ]] && [[ -f "${env}.tfvars" ]]; then
    terraform destroy -var-file="${env}.tfvars"
  elif [[ -n "$env" ]] && [[ -f "environments/${env}/terraform.tfvars" ]]; then
    terraform destroy -var-file="environments/${env}/terraform.tfvars"
  else
    terraform destroy
  fi
}
