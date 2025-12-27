# DevOps Tooling Guide

> Comprehensive reference for the DevOps tools and workflows included in these dotfiles.

This dotfiles setup includes extensive tooling for DevOps engineers working with:
- Infrastructure as Code (Terraform)
- Container Orchestration (Kubernetes, Helm)
- GitOps (ArgoCD)
- Cloud Platforms (AWS, GCP, Azure)
- CI/CD Pipelines

---

## Table of Contents

- [Quick Reference](#quick-reference)
- [Terraform](#terraform)
- [Kubernetes](#kubernetes)
- [AWS](#aws)
- [ArgoCD](#argocd)
- [Docker](#docker)

---

## Quick Reference

### Check All Tools Status

```bash
# Quick status of all DevOps tools
devops-status
```

Output:
```
DevOps Tools Status
===================
Kubernetes: my-cluster
Terraform: Terraform v1.6.0
AWS: 123456789012
ArgoCD: v2.9.0
Helm: v3.13.0
Docker: 24.0.0
```

---

## Terraform

### Aliases

| Alias | Command | Description |
|-------|---------|-------------|
| `tf` | `terraform` | Base command |
| `tfi` | `terraform init` | Initialize |
| `tfp` | `terraform plan` | Plan changes |
| `tfa` | `terraform apply` | Apply changes |
| `tfd` | `terraform destroy` | Destroy resources |
| `tfv` | `terraform validate` | Validate config |
| `tff` | `terraform fmt -recursive` | Format all files |
| `tfo` | `terraform output` | Show outputs |
| `tfs` | `terraform state` | State commands |
| `tfsl` | `terraform state list` | List state |
| `tfw` | `terraform workspace` | Workspace commands |
| `tfwl` | `terraform workspace list` | List workspaces |

### Functions

#### `tf-project <name> [provider]`
Create a new Terraform project with best-practice structure:

```bash
tf-project my-infrastructure aws
```

Creates:
```
my-infrastructure/
├── main.tf              # Provider and backend config
├── variables.tf         # Input variables
├── outputs.tf           # Outputs
├── .gitignore           # Terraform-specific ignores
├── README.md            # Documentation
├── modules/             # Reusable modules
└── environments/
    ├── dev/
    │   ├── terraform.tfvars
    │   └── backend.hcl
    ├── staging/
    └── prod/
```

#### `tf-init-backend <env>`
Initialize with environment-specific backend:

```bash
tf-init-backend prod
# Looks for: backend-prod.hcl or environments/prod/backend.hcl
```

#### `tf-plan-env <env>` / `tf-apply-env <env>`
Plan/apply with environment-specific tfvars:

```bash
tf-plan-env staging
tf-apply-env staging
```

#### `tf-check`
Run all validation and security tools:

```bash
tf-check
# Runs: terraform fmt -check, validate, tflint, tfsec, checkov
```

#### `tf-cost <env>`
Estimate costs using Infracost:

```bash
tf-cost prod
```

#### `tf-destroy-safe`
Destroy with double confirmation (for safety):

```bash
tf-destroy-safe prod
# Requires typing 'yes' then 'destroy'
```

---

## Kubernetes

### kubectl Aliases

| Alias | Command | Description |
|-------|---------|-------------|
| `k` | `kubectl` | Base command |
| `kg` | `kubectl get` | Get resources |
| `kgp` | `kubectl get pods` | Get pods |
| `kgpa` | `kubectl get pods -A` | Get all pods |
| `kgd` | `kubectl get deployments` | Get deployments |
| `kgs` | `kubectl get services` | Get services |
| `kgn` | `kubectl get nodes` | Get nodes |
| `kd` | `kubectl describe` | Describe resource |
| `kdp` | `kubectl describe pod` | Describe pod |
| `kl` | `kubectl logs` | Get logs |
| `klf` | `kubectl logs -f` | Follow logs |
| `ke` | `kubectl exec -it` | Exec into pod |
| `ka` | `kubectl apply -f` | Apply manifest |
| `kdel` | `kubectl delete` | Delete resource |
| `kpf` | `kubectl port-forward` | Port forward |
| `kro` | `kubectl rollout` | Rollout commands |
| `kror` | `kubectl rollout restart` | Restart deployment |

### Helm Aliases

| Alias | Command | Description |
|-------|---------|-------------|
| `h` | `helm` | Base command |
| `hi` | `helm install` | Install chart |
| `hu` | `helm upgrade` | Upgrade release |
| `hui` | `helm upgrade --install` | Install or upgrade |
| `hl` | `helm list` | List releases |
| `hla` | `helm list --all` | List all releases |
| `hs` | `helm search` | Search charts |
| `hr` | `helm repo` | Repo commands |
| `hru` | `helm repo update` | Update repos |

### Functions

#### `kctx-switch` / `kns-switch`
Fuzzy context/namespace switching (requires fzf):

```bash
kctx-switch    # Select cluster context
kns-switch     # Select namespace
```

#### `kexec` / `klogs` / `kdesc`
Fuzzy pod selection for common operations:

```bash
kexec          # Select pod → exec into it
klogs          # Select pod → tail logs
kdesc          # Select pod → describe it
```

#### `kdebug [image]`
Launch a debug container:

```bash
kdebug                     # Uses nicolaka/netshoot
kdebug busybox             # Use specific image
```

#### `kall [namespace]`
List all resources in a namespace:

```bash
kall
kall production
```

#### `ksec-view [secret]`
Decode and view secret values:

```bash
ksec-view                  # Fuzzy select secret
ksec-view my-secret        # View specific secret
```

#### `krestart [deployment]`
Restart deployment and watch status:

```bash
krestart                   # Fuzzy select deployment
krestart my-app            # Restart specific deployment
```

---

## AWS

### Profile Management

```bash
aws-profiles               # List all profiles
aws-profile                # Fuzzy select profile
aws-profile prod           # Switch to specific profile
aws-sso-login prod         # SSO login for profile
```

### Common Aliases

| Alias | Description |
|-------|-------------|
| `awsw` | Who am I? (sts get-caller-identity) |
| `ec2ls` | List EC2 instances (table format) |
| `ec2run` | List running instances |
| `s3ls` | List S3 buckets |
| `eksls` | List EKS clusters |
| `lambdals` | List Lambda functions |
| `rdsls` | List RDS instances |

### Functions

#### `ec2-ssm [instance-id]`
SSM session to EC2 instance:

```bash
ec2-ssm                    # Fuzzy select from running instances
ec2-ssm i-1234567890       # Connect to specific instance
```

#### `eks-config [cluster]`
Update kubeconfig for EKS cluster:

```bash
eks-config                 # Fuzzy select cluster
eks-config my-cluster      # Configure specific cluster
```

#### `cw-logs [log-group] [minutes]`
Tail CloudWatch logs:

```bash
cw-logs                    # Fuzzy select log group
cw-logs /aws/lambda/my-fn 60   # Last 60 minutes
```

#### `aws-cost`
Show last month's costs by service:

```bash
aws-cost
```

---

## ArgoCD

### Aliases

| Alias | Command | Description |
|-------|---------|-------------|
| `argo` | `argocd` | Base command |
| `argols` | `argocd app list` | List apps |
| `argosync` | `argocd app sync` | Sync app |
| `argodiff` | `argocd app diff` | Show diff |
| `argohist` | `argocd app history` | Show history |
| `argoroll` | `argocd app rollback` | Rollback |

### Functions

#### `argo-init-password [namespace]`
Get initial admin password:

```bash
argo-init-password
argo-init-password argocd
```

#### `argo-port-forward [namespace] [port]`
Port forward to ArgoCD server:

```bash
argo-port-forward          # localhost:8080
argo-port-forward argocd 9090   # Custom port
```

#### `argo-sync-select`
Fuzzy select app to sync:

```bash
argo-sync-select
```

#### `argo-dashboard`
Show summary of all apps, clusters, repos:

```bash
argo-dashboard
```

#### `argo-out-of-sync` / `argo-unhealthy`
List problem applications:

```bash
argo-out-of-sync           # Apps not synced
argo-unhealthy             # Degraded apps
```

---

## Docker

### Aliases

| Alias | Command | Description |
|-------|---------|-------------|
| `d` | `docker` | Base command |
| `dc` | `docker-compose` | Compose |
| `dps` | `docker ps` | List containers |
| `di` | `docker images` | List images |
| `dlogs` | `docker logs` | View logs |
| `dexec` | `docker exec -it` | Exec into container |
| `dstop` | Stop all containers | `docker stop $(docker ps -q)` |
| `dprune` | `docker system prune -a` | Clean up |

---

## Tips & Best Practices

### 1. Use Fuzzy Selection

Most functions support fuzzy selection via fzf. Just run without arguments:

```bash
kexec          # Instead of: kubectl exec -it <pod> -- /bin/sh
ec2-ssm        # Instead of: aws ssm start-session --target <id>
argo-sync-select  # Instead of: argocd app sync <app>
```

### 2. Check Status First

```bash
devops-status  # Verify all tools are configured
```

### 3. Use Safe Destroy

```bash
tf-destroy-safe prod  # Double confirmation prevents accidents
```

### 4. Leverage Tab Completion

All tools have completion configured. Use `<Tab>` liberally.
