#!/usr/bin/env zsh

# terraform.zsh
# Author: Thomas Vincent
# GitHub: https://github.com/thomasvincent/dotfiles
#
# This file contains Terraform-specific configuration.

# Terraform aliases
alias tf="terraform"
alias tfi="terraform init"
alias tfp="terraform plan"
alias tfa="terraform apply"
alias tfaa="terraform apply -auto-approve"
alias tfd="terraform destroy"
alias tfda="terraform destroy -auto-approve"
alias tfo="terraform output"
alias tfs="terraform state"
alias tfsl="terraform state list"
alias tfss="terraform state show"
alias tfv="terraform validate"
alias tfw="terraform workspace"
alias tfwl="terraform workspace list"
alias tfws="terraform workspace select"
alias tfwn="terraform workspace new"
alias tfwd="terraform workspace delete"
alias tfg="terraform graph | dot -Tsvg > graph.svg && open graph.svg"
alias tfc="terraform console"
alias tfr="terraform refresh"
alias tffmt="terraform fmt -recursive"

# If terragrunt is installed
if command -v terragrunt &> /dev/null; then
  alias tg="terragrunt"
  alias tgp="terragrunt plan"
  alias tga="terragrunt apply"
  alias tgaa="terragrunt apply -auto-approve"
  alias tgd="terragrunt destroy"
  alias tgda="terragrunt destroy -auto-approve"
  alias tgo="terragrunt output"
fi

# Terraform functions

# Initialize Terraform with backend configuration
tf-init-backend() {
  if [ $# -lt 1 ]; then
    echo "Usage: tf-init-backend <backend-config-file>"
    return 1
  fi
  
  terraform init -backend-config="$1"
}

# Initialize Terraform with backend configuration and reconfigure
tf-init-backend-reconfigure() {
  if [ $# -lt 1 ]; then
    echo "Usage: tf-init-backend-reconfigure <backend-config-file>"
    return 1
  fi
  
  terraform init -reconfigure -backend-config="$1"
}

# Initialize Terraform with backend configuration and migrate state
tf-init-backend-migrate() {
  if [ $# -lt 1 ]; then
    echo "Usage: tf-init-backend-migrate <backend-config-file>"
    return 1
  fi
  
  terraform init -migrate-state -backend-config="$1"
}

# Initialize Terraform with backend configuration and force copy
tf-init-backend-force-copy() {
  if [ $# -lt 1 ]; then
    echo "Usage: tf-init-backend-force-copy <backend-config-file>"
    return 1
  fi
  
  terraform init -force-copy -backend-config="$1"
}

# Initialize Terraform with backend configuration and upgrade
tf-init-backend-upgrade() {
  if [ $# -lt 1 ]; then
    echo "Usage: tf-init-backend-upgrade <backend-config-file>"
    return 1
  fi
  
  terraform init -upgrade -backend-config="$1"
}

# Initialize Terraform with backend configuration, reconfigure, and upgrade
tf-init-backend-reconfigure-upgrade() {
  if [ $# -lt 1 ]; then
    echo "Usage: tf-init-backend-reconfigure-upgrade <backend-config-file>"
    return 1
  fi
  
  terraform init -reconfigure -upgrade -backend-config="$1"
}

# Initialize Terraform with backend configuration, migrate state, and upgrade
tf-init-backend-migrate-upgrade() {
  if [ $# -lt 1 ]; then
    echo "Usage: tf-init-backend-migrate-upgrade <backend-config-file>"
    return 1
  fi
  
  terraform init -migrate-state -upgrade -backend-config="$1"
}

# Initialize Terraform with backend configuration, force copy, and upgrade
tf-init-backend-force-copy-upgrade() {
  if [ $# -lt 1 ]; then
    echo "Usage: tf-init-backend-force-copy-upgrade <backend-config-file>"
    return 1
  fi
  
  terraform init -force-copy -upgrade -backend-config="$1"
}

# Plan Terraform with variables file
tf-plan-var-file() {
  if [ $# -lt 1 ]; then
    echo "Usage: tf-plan-var-file <var-file>"
    return 1
  fi
  
  terraform plan -var-file="$1"
}

# Plan Terraform with variables
tf-plan-var() {
  if [ $# -lt 1 ]; then
    echo "Usage: tf-plan-var <var1=value1> [var2=value2...]"
    return 1
  fi
  
  local vars=""
  for var in "$@"; do
    vars="$vars -var=\"$var\""
  done
  
  eval "terraform plan $vars"
}

# Plan Terraform with variables file and output to file
tf-plan-var-file-out() {
  if [ $# -lt 2 ]; then
    echo "Usage: tf-plan-var-file-out <var-file> <out-file>"
    return 1
  fi
  
  terraform plan -var-file="$1" -out="$2"
}

# Plan Terraform with variables and output to file
tf-plan-var-out() {
  if [ $# -lt 2 ]; then
    echo "Usage: tf-plan-var-out <out-file> <var1=value1> [var2=value2...]"
    return 1
  fi
  
  local out_file="$1"
  shift
  
  local vars=""
  for var in "$@"; do
    vars="$vars -var=\"$var\""
  done
  
  eval "terraform plan $vars -out=\"$out_file\""
}

# Apply Terraform with variables file
tf-apply-var-file() {
  if [ $# -lt 1 ]; then
    echo "Usage: tf-apply-var-file <var-file>"
    return 1
  fi
  
  terraform apply -var-file="$1"
}

# Apply Terraform with variables
tf-apply-var() {
  if [ $# -lt 1 ]; then
    echo "Usage: tf-apply-var <var1=value1> [var2=value2...]"
    return 1
  fi
  
  local vars=""
  for var in "$@"; do
    vars="$vars -var=\"$var\""
  done
  
  eval "terraform apply $vars"
}

# Apply Terraform with variables file and auto-approve
tf-apply-var-file-auto-approve() {
  if [ $# -lt 1 ]; then
    echo "Usage: tf-apply-var-file-auto-approve <var-file>"
    return 1
  fi
  
  terraform apply -var-file="$1" -auto-approve
}

# Apply Terraform with variables and auto-approve
tf-apply-var-auto-approve() {
  if [ $# -lt 1 ]; then
    echo "Usage: tf-apply-var-auto-approve <var1=value1> [var2=value2...]"
    return 1
  fi
  
  local vars=""
  for var in "$@"; do
    vars="$vars -var=\"$var\""
  done
  
  eval "terraform apply -auto-approve $vars"
}

# Destroy Terraform with variables file
tf-destroy-var-file() {
  if [ $# -lt 1 ]; then
    echo "Usage: tf-destroy-var-file <var-file>"
    return 1
  fi
  
  terraform destroy -var-file="$1"
}

# Destroy Terraform with variables
tf-destroy-var() {
  if [ $# -lt 1 ]; then
    echo "Usage: tf-destroy-var <var1=value1> [var2=value2...]"
    return 1
  fi
  
  local vars=""
  for var in "$@"; do
    vars="$vars -var=\"$var\""
  done
  
  eval "terraform destroy $vars"
}

# Destroy Terraform with variables file and auto-approve
tf-destroy-var-file-auto-approve() {
  if [ $# -lt 1 ]; then
    echo "Usage: tf-destroy-var-file-auto-approve <var-file>"
    return 1
  fi
  
  terraform destroy -var-file="$1" -auto-approve
}

# Destroy Terraform with variables and auto-approve
tf-destroy-var-auto-approve() {
  if [ $# -lt 1 ]; then
    echo "Usage: tf-destroy-var-auto-approve <var1=value1> [var2=value2...]"
    return 1
  fi
  
  local vars=""
  for var in "$@"; do
    vars="$vars -var=\"$var\""
  done
  
  eval "terraform destroy -auto-approve $vars"
}

# Output Terraform with specific output
tf-output-specific() {
  if [ $# -lt 1 ]; then
    echo "Usage: tf-output-specific <output-name>"
    return 1
  fi
  
  terraform output "$1"
}

# Output Terraform with specific output in JSON format
tf-output-specific-json() {
  if [ $# -lt 1 ]; then
    echo "Usage: tf-output-specific-json <output-name>"
    return 1
  fi
  
  terraform output -json "$1"
}

# Output Terraform in JSON format
tf-output-json() {
  terraform output -json
}

# State list Terraform with specific resource
tf-state-list-specific() {
  if [ $# -lt 1 ]; then
    echo "Usage: tf-state-list-specific <resource-name>"
    return 1
  fi
  
  terraform state list "$1"
}

# State show Terraform with specific resource
tf-state-show-specific() {
  if [ $# -lt 1 ]; then
    echo "Usage: tf-state-show-specific <resource-name>"
    return 1
  fi
  
  terraform state show "$1"
}

# State pull Terraform
tf-state-pull() {
  terraform state pull
}

# State push Terraform
tf-state-push() {
  if [ $# -lt 1 ]; then
    echo "Usage: tf-state-push <state-file>"
    return 1
  fi
  
  terraform state push "$1"
}

# State rm Terraform
tf-state-rm() {
  if [ $# -lt 1 ]; then
    echo "Usage: tf-state-rm <resource-name>"
    return 1
  fi
  
  terraform state rm "$1"
}

# State mv Terraform
tf-state-mv() {
  if [ $# -lt 2 ]; then
    echo "Usage: tf-state-mv <source> <destination>"
    return 1
  fi
  
  terraform state mv "$1" "$2"
}

# State replace-provider Terraform
tf-state-replace-provider() {
  if [ $# -lt 2 ]; then
    echo "Usage: tf-state-replace-provider <old-provider> <new-provider>"
    return 1
  fi
  
  terraform state replace-provider "$1" "$2"
}

# Import Terraform
tf-import() {
  if [ $# -lt 2 ]; then
    echo "Usage: tf-import <resource-name> <id>"
    return 1
  fi
  
  terraform import "$1" "$2"
}

# Import Terraform with variables file
tf-import-var-file() {
  if [ $# -lt 3 ]; then
    echo "Usage: tf-import-var-file <resource-name> <id> <var-file>"
    return 1
  fi
  
  terraform import -var-file="$3" "$1" "$2"
}

# Import Terraform with variables
tf-import-var() {
  if [ $# -lt 3 ]; then
    echo "Usage: tf-import-var <resource-name> <id> <var1=value1> [var2=value2...]"
    return 1
  fi
  
  local resource_name="$1"
  local id="$2"
  shift 2
  
  local vars=""
  for var in "$@"; do
    vars="$vars -var=\"$var\""
  done
  
  eval "terraform import $vars \"$resource_name\" \"$id\""
}

# Workspace new Terraform
tf-workspace-new() {
  if [ $# -lt 1 ]; then
    echo "Usage: tf-workspace-new <workspace-name>"
    return 1
  fi
  
  terraform workspace new "$1"
}

# Workspace select Terraform
tf-workspace-select() {
  if [ $# -lt 1 ]; then
    echo "Usage: tf-workspace-select <workspace-name>"
    return 1
  fi
  
  terraform workspace select "$1"
}

# Workspace delete Terraform
tf-workspace-delete() {
  if [ $# -lt 1 ]; then
    echo "Usage: tf-workspace-delete <workspace-name>"
    return 1
  fi
  
  terraform workspace delete "$1"
}

# Workspace list Terraform
tf-workspace-list() {
  terraform workspace list
}

# Workspace show Terraform
tf-workspace-show() {
  terraform workspace show
}

# Console Terraform with variables file
tf-console-var-file() {
  if [ $# -lt 1 ]; then
    echo "Usage: tf-console-var-file <var-file>"
    return 1
  fi
  
  terraform console -var-file="$1"
}

# Console Terraform with variables
tf-console-var() {
  if [ $# -lt 1 ]; then
    echo "Usage: tf-console-var <var1=value1> [var2=value2...]"
    return 1
  fi
  
  local vars=""
  for var in "$@"; do
    vars="$vars -var=\"$var\""
  done
  
  eval "terraform console $vars"
}

# Refresh Terraform with variables file
tf-refresh-var-file() {
  if [ $# -lt 1 ]; then
    echo "Usage: tf-refresh-var-file <var-file>"
    return 1
  fi
  
  terraform refresh -var-file="$1"
}

# Refresh Terraform with variables
tf-refresh-var() {
  if [ $# -lt 1 ]; then
    echo "Usage: tf-refresh-var <var1=value1> [var2=value2...]"
    return 1
  fi
  
  local vars=""
  for var in "$@"; do
    vars="$vars -var=\"$var\""
  done
  
  eval "terraform refresh $vars"
}

# Format Terraform
tf-fmt() {
  terraform fmt -recursive
}

# Format Terraform and check
tf-fmt-check() {
  terraform fmt -recursive -check
}

# Format Terraform and diff
tf-fmt-diff() {
  terraform fmt -recursive -diff
}

# Format Terraform and write
tf-fmt-write() {
  terraform fmt -recursive -write=true
}

# Format Terraform and check and write
tf-fmt-check-write() {
  terraform fmt -recursive -check -write=true
}

# Format Terraform and diff and write
tf-fmt-diff-write() {
  terraform fmt -recursive -diff -write=true
}

# Validate Terraform
tf-validate() {
  terraform validate
}

# Validate Terraform with variables file
tf-validate-var-file() {
  if [ $# -lt 1 ]; then
    echo "Usage: tf-validate-var-file <var-file>"
    return 1
  fi
  
  terraform validate -var-file="$1"
}

# Validate Terraform with variables
tf-validate-var() {
  if [ $# -lt 1 ]; then
    echo "Usage: tf-validate-var <var1=value1> [var2=value2...]"
    return 1
  fi
  
  local vars=""
  for var in "$@"; do
    vars="$vars -var=\"$var\""
  done
  
  eval "terraform validate $vars"
}

# Graph Terraform
tf-graph() {
  terraform graph
}

# Graph Terraform and output to file
tf-graph-out() {
  if [ $# -lt 1 ]; then
    echo "Usage: tf-graph-out <out-file>"
    return 1
  fi
  
  terraform graph > "$1"
}

# Graph Terraform and output to SVG file
tf-graph-svg() {
  if [ $# -lt 1 ]; then
    echo "Usage: tf-graph-svg <out-file>"
    return 1
  fi
  
  terraform graph | dot -Tsvg > "$1"
}

# Graph Terraform and output to PNG file
tf-graph-png() {
  if [ $# -lt 1 ]; then
    echo "Usage: tf-graph-png <out-file>"
    return 1
  fi
  
  terraform graph | dot -Tpng > "$1"
}

# Graph Terraform and output to PDF file
tf-graph-pdf() {
  if [ $# -lt 1 ]; then
    echo "Usage: tf-graph-pdf <out-file>"
    return 1
  fi
  
  terraform graph | dot -Tpdf > "$1"
}

# Graph Terraform and output to SVG file and open
tf-graph-svg-open() {
  if [ $# -lt 1 ]; then
    echo "Usage: tf-graph-svg-open <out-file>"
    return 1
  fi
  
  terraform graph | dot -Tsvg > "$1" && open "$1"
}

# Graph Terraform and output to PNG file and open
tf-graph-png-open() {
  if [ $# -lt 1 ]; then
    echo "Usage: tf-graph-png-open <out-file>"
    return 1
  fi
  
  terraform graph | dot -Tpng > "$1" && open "$1"
}

# Graph Terraform and output to PDF file and open
tf-graph-pdf-open() {
  if [ $# -lt 1 ]; then
    echo "Usage: tf-graph-pdf-open <out-file>"
    return 1
  fi
  
  terraform graph | dot -Tpdf > "$1" && open "$1"
}

# Providers Terraform
tf-providers() {
  terraform providers
}

# Providers lock Terraform
tf-providers-lock() {
  terraform providers lock
}

# Providers mirror Terraform
tf-providers-mirror() {
  if [ $# -lt 1 ]; then
    echo "Usage: tf-providers-mirror <directory>"
    return 1
  fi
  
  terraform providers mirror "$1"
}

# Providers schema Terraform
tf-providers-schema() {
  terraform providers schema
}

# Providers schema Terraform in JSON format
tf-providers-schema-json() {
  terraform providers schema -json
}

# Get Terraform
tf-get() {
  terraform get
}

# Get Terraform and update
tf-get-update() {
  terraform get -update
}

# Taint Terraform
tf-taint() {
  if [ $# -lt 1 ]; then
    echo "Usage: tf-taint <resource-name>"
    return 1
  fi
  
  terraform taint "$1"
}

# Untaint Terraform
tf-untaint() {
  if [ $# -lt 1 ]; then
    echo "Usage: tf-untaint <resource-name>"
    return 1
  fi
  
  terraform untaint "$1"
}

# Force unlock Terraform
tf-force-unlock() {
  if [ $# -lt 1 ]; then
    echo "Usage: tf-force-unlock <lock-id>"
    return 1
  fi
  
  terraform force-unlock "$1"
}

# Force unlock Terraform and force
tf-force-unlock-force() {
  if [ $# -lt 1 ]; then
    echo "Usage: tf-force-unlock-force <lock-id>"
    return 1
  fi
  
  terraform force-unlock -force "$1"
}

# Show Terraform
tf-show() {
  if [ $# -lt 1 ]; then
    echo "Usage: tf-show <plan-file>"
    return 1
  fi
  
  terraform show "$1"
}

# Show Terraform in JSON format
tf-show-json() {
  if [ $# -lt 1 ]; then
    echo "Usage: tf-show-json <plan-file>"
    return 1
  fi
  
  terraform show -json "$1"
}

# Version Terraform
tf-version() {
  terraform version
}

# Version Terraform in JSON format
tf-version-json() {
  terraform version -json
}

# Terraform plan with target
tf-plan-target() {
  if [ $# -lt 1 ]; then
    echo "Usage: tf-plan-target <target> [target2...]"
    return 1
  fi
  
  local targets=""
  for target in "$@"; do
    targets="$targets -target=\"$target\""
  done
  
  eval "terraform plan $targets"
}

# Terraform apply with target
tf-apply-target() {
  if [ $# -lt 1 ]; then
    echo "Usage: tf-apply-target <target> [target2...]"
    return 1
  fi
  
  local targets=""
  for target in "$@"; do
    targets="$targets -target=\"$target\""
  done
  
  eval "terraform apply $targets"
}

# Terraform destroy with target
tf-destroy-target() {
  if [ $# -lt 1 ]; then
    echo "Usage: tf-destroy-target <target> [target2...]"
    return 1
  fi
  
  local targets=""
  for target in "$@"; do
    targets="$targets -target=\"$target\""
  done
  
  eval "terraform destroy $targets"
}

# Terraform plan with target and variables file
tf-plan-target-var-file() {
  if [ $# -lt 2 ]; then
    echo "Usage: tf-plan-target-var-file <var-file> <target> [target2...]"
    return 1
  fi
  
  local var_file="$1"
  shift
  
  local targets=""
  for target in "$@"; do
    targets="$targets -target=\"$target\""
  done
  
  eval "terraform plan -var-file=\"$var_file\" $targets"
}

# Terraform apply with target and variables file
tf-apply-target-var-file() {
  if [ $# -lt 2 ]; then
    echo "Usage: tf-apply-target-var-file <var-file> <target> [target2...]"
    return 1
  fi
  
  local var_file="$1"
  shift
  
  local targets=""
  for target in "$@"; do
    targets="$targets -target=\"$target\""
  done
  
  eval "terraform apply -var-file=\"$var_file\" $targets"
}

# Terraform destroy with target and variables file
tf-destroy-target-var-file() {
  if [ $# -lt 2 ]; then
    echo "Usage: tf-destroy-target-var-file <var-file> <target> [target2...]"
    return 1
  fi
  
  local var_file="$1"
  shift
  
  local targets=""
  for target in "$@"; do
    targets="$targets -target=\"$target\""
  done
  
  eval "terraform destroy -var-file=\"$var_file\" $targets"
}

# Terraform plan with target and variables
tf-plan-target-var() {
  if [ $# -lt 2 ]; then
    echo "Usage: tf-plan-target-var <target> <var1=value1> [var2=value2...]"
    return 1
  fi
  
  local target="$1"
  shift
  
  local vars=""
  for var in "$@"; do
    vars="$vars -var=\"$var\""
  done
  
  eval "terraform plan -target=\"$target\" $vars"
}

# Terraform apply with target and variables
tf-apply-target-var() {
  if [ $# -lt 2 ]; then
    echo "Usage: tf-apply-target-var <target> <var1=value1> [var2=value2...]"
    return 1
  fi
  
  local target="$1"
  shift
  
  local vars=""
  for var in "$@"; do
    vars="$vars -var=\"$var\""
  done
  
  eval "terraform apply -target=\"$target\" $vars"
}

# Terraform destroy with target and variables
tf-destroy-target-var() {
  if [ $# -lt 2 ]; then
    echo "Usage: tf-destroy-target-var <target> <var1=value1>
