# Dotfiles Makefile
# Provides targets for installation, configuration, and maintenance

# Set shell to bash
SHELL := /bin/bash

# Default target
.PHONY: all
all: help

# Get OS type for platform-specific commands
OS := $(shell uname)
ifeq ($(OS),Darwin)
	PLATFORM := macos
	BREW_PATH := $$(brew --prefix)
else ifeq ($(OS),Linux)
	PLATFORM := linux
else
	PLATFORM := unknown
endif

# Directories
HOME_DIR := $(HOME)
DOTFILES_DIR := $(HOME)/dotfiles
BACKUP_DIR := $(HOME)/dotfiles_backup_$(shell date +%Y%m%d_%H%M%S)
CONFIG_DIR := $(HOME)/.config
ZSH_DIR := $(HOME)/.zsh
LOCAL_BIN_DIR := $(HOME)/.local/bin
CHEZMOI_DIR := $(HOME)/.local/share/chezmoi

# Color definitions
RESET := \033[0m
BLUE := \033[0;34m
GREEN := \033[0;32m
RED := \033[0;31m
YELLOW := \033[0;33m

# Helper functions
define print_header
	@echo -e "$(BLUE)========== $(1) ==========$(RESET)"
endef

define print_success
	@echo -e "$(GREEN)✅ $(1)$(RESET)"
endef

define print_warning
	@echo -e "$(YELLOW)⚠️  $(1)$(RESET)"
endef

define print_error
	@echo -e "$(RED)❌ $(1)$(RESET)"
endef

.PHONY: help
help:
	@echo -e "$(BLUE)Dotfiles Management System$(RESET)"
	@echo -e "Available targets:"
	@echo -e "  $(YELLOW)install$(RESET)       - Install dotfiles with chezmoi"
	@echo -e "  $(YELLOW)update$(RESET)        - Update dotfiles"
	@echo -e "  $(YELLOW)backup$(RESET)        - Backup existing dotfiles"
	@echo -e "  $(YELLOW)dev-setup$(RESET)     - Set up development environment"
	@echo -e "  $(YELLOW)cloud-setup$(RESET)   - Configure cloud provider tools"
	@echo -e "  $(YELLOW)workflow-setup$(RESET) - Set up workflow automation tools"
	@echo -e "  $(YELLOW)productivity-setup$(RESET) - Set up productivity tools"
	@echo -e "  $(YELLOW)brew-install$(RESET)  - Install Homebrew packages"
	@echo -e "  $(YELLOW)test$(RESET)          - Test shell startup"
	@echo -e "  $(YELLOW)lint$(RESET)          - Run linters"
	@echo -e "  $(YELLOW)migrate$(RESET)       - Migrate to chezmoi"
	@echo -e "  $(YELLOW)functions$(RESET)     - Create placeholder function files"
	@echo -e "  $(YELLOW)clean$(RESET)         - Clean temporary files"

.PHONY: install
install: backup
	$(call print_header,Installing dotfiles)
	@if ! command -v chezmoi >/dev/null 2>&1; then \
		echo "Installing chezmoi..."; \
		if command -v brew >/dev/null 2>&1; then \
			brew install chezmoi; \
		else \
			sh -c "$$(curl -fsLS get.chezmoi.io)" -- -b $(LOCAL_BIN_DIR); \
			export PATH="$(LOCAL_BIN_DIR):$$PATH"; \
		fi; \
		$(call print_success,Chezmoi installed); \
	fi
	@echo "Initializing and applying dotfiles..."
	@chezmoi init $(DOTFILES_DIR)
	@chezmoi apply -v
	$(call print_success,Dotfiles installed)

.PHONY: update
update:
	$(call print_header,Updating dotfiles)
	@if command -v chezmoi >/dev/null 2>&1; then \
		chezmoi update -v; \
		$(call print_success,Dotfiles updated); \
	else \
		$(call print_error,Chezmoi not installed. Run 'make install' first); \
		exit 1; \
	fi

.PHONY: backup
backup:
	$(call print_header,Backing up existing dotfiles)
	@mkdir -p $(BACKUP_DIR)
	@for file in .zshrc .zshenv .zprofile .gitconfig .vim .tmux.conf; do \
		if [ -e "$(HOME)/$$file" ]; then \
			cp -R "$(HOME)/$$file" "$(BACKUP_DIR)/"; \
			echo "Backed up $$file"; \
		fi; \
	done
	$(call print_success,Backup created at $(BACKUP_DIR))

.PHONY: dev-setup
dev-setup:
	$(call print_header,Setting up development environment)
	@if [ "$(PLATFORM)" = "macos" ]; then \
		if [ -f "$(DOTFILES_DIR)/Brewfile.dev" ]; then \
			echo "Installing development tools..."; \
			brew bundle install --file="$(DOTFILES_DIR)/Brewfile.dev"; \
			$(call print_success,Development tools installed); \
		fi; \
	elif [ "$(PLATFORM)" = "linux" ]; then \
		if command -v apt-get >/dev/null 2>&1; then \
			echo "Installing development tools..."; \
			sudo apt-get update; \
			sudo apt-get install -y git zsh curl wget ripgrep fd-find bat tmux neovim python3-pip; \
			$(call print_success,Development tools installed); \
		fi; \
	fi
	@echo "Setting up language environments..."
	@if command -v asdf >/dev/null 2>&1; then \
		asdf plugin add nodejs || true; \
		asdf plugin add python || true; \
		asdf plugin add ruby || true; \
		asdf plugin add java || true; \
		asdf plugin add golang || true; \
		asdf install nodejs latest; \
		asdf install python latest; \
		asdf install ruby latest; \
		asdf install java temurin-17.0.9+9; \
		asdf install golang latest; \
		asdf global nodejs latest; \
		asdf global python latest; \
		asdf global ruby latest; \
		asdf global java temurin-17.0.9+9; \
		asdf global golang latest; \
		$(call print_success,Language environments configured); \
	else \
		$(call print_warning,ASDF not installed, skipping language setup); \
	fi

.PHONY: cloud-setup
cloud-setup:
	$(call print_header,Setting up cloud tool integrations)
	@if command -v brew >/dev/null 2>&1; then \
		echo "Installing cloud provider tools..."; \
		brew install awscli azure-cli terraform doctl gh; \
	elif command -v apt-get >/dev/null 2>&1; then \
		echo "Adding cloud provider repositories..."; \
		curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -; \
		sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com focal main"; \
		sudo apt-get update; \
		sudo apt-get install -y awscli terraform; \
	fi
	@echo "Configuring cloud provider credentials..."
	@mkdir -p $(HOME)/.aws $(HOME)/.azure $(HOME)/.config/digitalocean
	@touch $(HOME)/.aws/config
	@if command -v gh >/dev/null 2>&1; then \
		echo "Generating GitHub CLI completions..."; \
		mkdir -p "$(ZSH_DIR)/completions"; \
		gh completion -s zsh > "$(ZSH_DIR)/completions/_gh"; \
	fi
	@if command -v doctl >/dev/null 2>&1; then \
		echo "Generating DigitalOcean CLI completions..."; \
		mkdir -p "$(ZSH_DIR)/completions"; \
		doctl completion zsh > "$(ZSH_DIR)/completions/_doctl"; \
	fi
	$(call print_success,Cloud tools setup complete)

.PHONY: brew-install
brew-install:
	$(call print_header,Installing Homebrew packages)
	@if [ "$(PLATFORM)" = "macos" ]; then \
		if ! command -v brew >/dev/null 2>&1; then \
			echo "Installing Homebrew..."; \
			/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; \
			if [ "$$(uname -m)" = "arm64" ]; then \
				eval "$$(/opt/homebrew/bin/brew shellenv)"; \
			else \
				eval "$$(/usr/local/bin/brew shellenv)"; \
			fi; \
		fi; \
		if [ -f "$(DOTFILES_DIR)/Brewfile" ]; then \
			echo "Installing packages from Brewfile..."; \
			brew bundle install --file="$(DOTFILES_DIR)/Brewfile"; \
		fi; \
		if [ -f "$(DOTFILES_DIR)/Brewfile.recommended" ]; then \
			echo "Installing recommended packages..."; \
			brew bundle install --file="$(DOTFILES_DIR)/Brewfile.recommended"; \
		fi; \
		$(call print_success,Homebrew packages installed); \
	else \
		$(call print_warning,Not on macOS, skipping Homebrew installation); \
	fi

.PHONY: test
test:
	$(call print_header,Testing shell startup)
	@export ZSH_TEST_MODE=1; \
	TMP_SCRIPT=$$(mktemp /tmp/zsh_test_XXXXXX.zsh); \
	TMP_ERR=$$(mktemp /tmp/zsh_err_XXXXXX.log); \
	echo '# Test script for shell startup' > $$TMP_SCRIPT; \
	echo 'exec 2>"$$1"' >> $$TMP_SCRIPT; \
	echo 'source ~/.zshrc' >> $$TMP_SCRIPT; \
	echo 'exit 0' >> $$TMP_SCRIPT; \
	chmod +x $$TMP_SCRIPT; \
	zsh $$TMP_SCRIPT $$TMP_ERR; \
	if [ -s $$TMP_ERR ]; then \
		$(call print_error,Errors detected during startup:); \
		cat $$TMP_ERR; \
	else \
		$(call print_success,No errors detected during shell startup!); \
	fi; \
	rm -f $$TMP_SCRIPT $$TMP_ERR

.PHONY: lint
lint:
	$(call print_header,Running linters)
	@if command -v pre-commit >/dev/null 2>&1; then \
		pre-commit run --all-files; \
	else \
		$(call print_warning,pre-commit not installed, installing...); \
		pip3 install pre-commit; \
		pre-commit install; \
		pre-commit run --all-files; \
	fi
	@if command -v shellcheck >/dev/null 2>&1; then \
		echo "Running shellcheck on scripts..."; \
		for file in $$(find $(DOTFILES_DIR) -name "*.sh" -type f); do \
			shellcheck -S warning $$file; \
		done; \
	fi
	@if command -v yamllint >/dev/null 2>&1; then \
		echo "Running yamllint on YAML files..."; \
		for file in $$(find $(DOTFILES_DIR) -name "*.yml" -o -name "*.yaml" -type f); do \
			yamllint $$file; \
		done; \
	fi
	$(call print_success,Linting complete)

.PHONY: migrate
migrate:
	$(call print_header,Migrating to chezmoi)
	@if [ -f "$(DOTFILES_DIR)/migrate-to-chezmoi.sh" ]; then \
		bash "$(DOTFILES_DIR)/migrate-to-chezmoi.sh"; \
	else \
		$(call print_error,Migration script not found); \
		exit 1; \
	fi

.PHONY: functions
functions:
	$(call print_header,Creating placeholder function files)
	@mkdir -p "$(DOTFILES_DIR)/.zsh/functions.d"
	@for func in 400_dev.zsh 500_cloud.zsh 600_containers.zsh 700_network.zsh 800_security.zsh 900_misc.zsh; do \
		if [ ! -f "$(DOTFILES_DIR)/.zsh/functions.d/$$func" ]; then \
			echo "Creating $$func..."; \
			echo "#!/usr/bin/env zsh" > "$(DOTFILES_DIR)/.zsh/functions.d/$$func"; \
			echo "# $$func - Function file for dotfiles" >> "$(DOTFILES_DIR)/.zsh/functions.d/$$func"; \
			echo "# This is a placeholder file to prevent errors during shell startup" >> "$(DOTFILES_DIR)/.zsh/functions.d/$$func"; \
			chmod +x "$(DOTFILES_DIR)/.zsh/functions.d/$$func"; \
		fi; \
	done
	$(call print_success,Function files created)

.PHONY: workflow-setup
workflow-setup:
	$(call print_header,Setting up workflow automation)
	@mkdir -p "$(HOME)/Projects"
	@if command -v gh >/dev/null 2>&1; then \
		echo "GitHub CLI already installed."; \
	elif [ "$(PLATFORM)" = "macos" ]; then \
		echo "Installing GitHub CLI..."; \
		brew install gh; \
	elif command -v apt-get >/dev/null 2>&1; then \
		echo "Installing GitHub CLI..."; \
		curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/etc/apt/trusted.gpg.d/githubcli-archive-keyring.gpg; \
		echo "deb [arch=$$(dpkg --print-architecture)] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list; \
		sudo apt-get update; \
		sudo apt-get install -y gh; \
	elif command -v dnf >/dev/null 2>&1; then \
		echo "Installing GitHub CLI..."; \
		sudo dnf install -y 'dnf-command(config-manager)'; \
		sudo dnf config-manager --add-repo https://cli.github.com/packages/rpm/gh-cli.repo; \
		sudo dnf install -y gh; \
	fi
	@if ! command -v tmux >/dev/null 2>&1; then \
		echo "Installing tmux..."; \
		if [ "$(PLATFORM)" = "macos" ]; then \
			brew install tmux; \
		elif command -v apt-get >/dev/null 2>&1; then \
			sudo apt-get install -y tmux; \
		elif command -v dnf >/dev/null 2>&1; then \
			sudo dnf install -y tmux; \
		fi; \
	fi
	@echo "Linking workflow functions..."
	@mkdir -p "$(ZSH_DIR)"
	@if [ -f "$(DOTFILES_DIR)/home/dot_zsh/workflows.zsh.tmpl" ]; then \
		cp "$(DOTFILES_DIR)/home/dot_zsh/workflows.zsh.tmpl" "$(ZSH_DIR)/workflows.zsh"; \
	fi
	$(call print_success,Workflow automation setup complete)

.PHONY: productivity-setup
productivity-setup:
	$(call print_header,Setting up productivity tools)
	@mkdir -p "$(HOME)/.tasks"
	@mkdir -p "$(HOME)/.notes/meetings"
	@mkdir -p "$(HOME)/.timetrack"
	@echo "Linking productivity functions..."
	@mkdir -p "$(ZSH_DIR)"
	@if [ -f "$(DOTFILES_DIR)/home/dot_zsh/productivity.zsh.tmpl" ]; then \
		cp "$(DOTFILES_DIR)/home/dot_zsh/productivity.zsh.tmpl" "$(ZSH_DIR)/productivity.zsh"; \
	fi
	@if [ "$(PLATFORM)" = "macos" ]; then \
		echo "Creating a small helper for macOS notifications..."; \
		mkdir -p "$(LOCAL_BIN_DIR)"; \
		echo '#!/bin/bash' > "$(LOCAL_BIN_DIR)/notify"; \
		echo 'osascript -e "display notification \"$2\" with title \"$1\" sound name \"Glass\""' >> "$(LOCAL_BIN_DIR)/notify"; \
		chmod +x "$(LOCAL_BIN_DIR)/notify"; \
	elif command -v apt-get >/dev/null 2>&1; then \
		echo "Installing libnotify..."; \
		sudo apt-get install -y libnotify-bin; \
	fi
	$(call print_success,Productivity tools setup complete)

.PHONY: clean
clean:
	$(call print_header,Cleaning temporary files)
	@find "$(DOTFILES_DIR)" -name "*.bak" -delete -print
	@find "$(DOTFILES_DIR)" -name "*~" -delete -print
	@find "$(DOTFILES_DIR)" -name ".DS_Store" -delete -print
	@rm -rf $(HOME)/.zsh/cache/*
	$(call print_success,Temporary files cleaned)