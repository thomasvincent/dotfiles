# Quick Reference Card

> Print this page for a handy reference of the most useful commands.

---

## DevOps Status

```bash
devops-status              # Check all DevOps tools
scripts/health-check.sh    # Full health check
```

---

## Terraform

| Command | Description |
|---------|-------------|
| `tf` | terraform |
| `tfi` | terraform init |
| `tfp` | terraform plan |
| `tfa` | terraform apply |
| `tf-project <name>` | Create new project |
| `tf-check` | Run all linters |
| `tf-cost` | Estimate costs |

---

## Kubernetes

| Command | Description |
|---------|-------------|
| `k` | kubectl |
| `kgp` | Get pods |
| `kgpa` | Get all pods |
| `klf` | Follow logs |
| `kexec` | Exec into pod (fuzzy) |
| `klogs` | Tail logs (fuzzy) |
| `ksec-view` | View secret |
| `krestart` | Restart deployment |
| `kctx-switch` | Switch context |
| `kns-switch` | Switch namespace |

---

## AWS

| Command | Description |
|---------|-------------|
| `awsw` | Who am I? |
| `aws-profile` | Switch profile |
| `ec2-ssm` | SSM into instance |
| `eks-config` | Update kubeconfig |
| `cw-logs` | Tail CloudWatch |
| `aws-cost` | Show costs |

---

## Docker

| Command | Description |
|---------|-------------|
| `d` | docker |
| `dc` | docker compose |
| `dps` | List containers |
| `dexec` | Exec into container |
| `dshell` | Shell into container (fuzzy) |
| `dstopall` | Stop all containers |
| `docker-clean` | Full cleanup |

---

## Git

| Command | Description |
|---------|-------------|
| `g` | git |
| `gs` | git status |
| `gco` | git checkout |
| `gcf "msg"` | feat: commit |
| `gcx "msg"` | fix: commit |
| `gci` | Interactive commit |
| `git-standup` | What did I do? |
| `git-sync` | Rebase on main |
| `gpr "title"` | Create PR |

---

## Network

| Command | Description |
|---------|-------------|
| `myip` | Show IP addresses |
| `ports` | Show listening ports |
| `http-headers <url>` | Show headers |
| `http-time <url>` | Show timing |
| `ssl-check <domain>` | Check certificate |
| `api-get <url>` | GET with jq |
| `jwt-decode <token>` | Decode JWT |

---

## Navigation

| Command | Description |
|---------|-------------|
| `..` | cd .. |
| `...` | cd ../.. |
| `cdp` | cd ~/Projects |
| `cdd` | cd ~/Downloads |
| `z <partial>` | Jump to directory |

---

## Files

| Command | Description |
|---------|-------------|
| `ll` | ls -lah |
| `lt` | Tree view |
| `f <name>` | Find file |
| `extract <file>` | Extract archive |
| `backup <file>` | Timestamped backup |

---

## Shell

| Command | Description |
|---------|-------------|
| `sz` | Reload .zshrc |
| `ez` | Edit .zshrc |
| `ea` | Edit aliases |
| `path` | Show PATH |

---

## Project Init

```bash
init-project node my-api
init-project python ml-project
init-project terraform infra
init-project docker my-service
```

---

## Documentation

```bash
docs node          # Open Node.js docs
docs k8s           # Open Kubernetes docs
docs terraform     # Open Terraform docs
docs aws           # Open AWS docs
```
