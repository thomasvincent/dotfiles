# Troubleshooting Guide

Solutions for common issues with these dotfiles.

## Shell Startup Issues

### Shell is slow to start

**Symptoms:** Noticeable delay when opening new terminal

**Solutions:**

1. Profile startup time:
   ```bash
   time zsh -i -c exit
   ```

2. Identify slow components:
   ```bash
   # Add to top of .zshrc
   zmodload zsh/zprof
   # Add to bottom of .zshrc
   zprof
   ```

3. Clear completion cache:
   ```bash
   rm -f ~/.zcompdump*
   rm -rf ~/.zsh/cache/*
   ```

4. Disable unused modules in `chezmoi.toml`:
   ```toml
   [data]
     enable_cloud = false  # If not using cloud tools
   ```

### Command not found errors

**Symptoms:** `command not found: xyz` on startup

**Solutions:**

1. Check if tool is installed:
   ```bash
   which xyz
   brew list | grep xyz
   ```

2. Install missing tools:
   ```bash
   brew bundle --file=Brewfile
   ```

3. Verify PATH:
   ```bash
   echo $PATH | tr ':' '\n'
   ```

### Syntax errors on startup

**Symptoms:** Parse errors when shell starts

**Solutions:**

1. Check for syntax errors:
   ```bash
   zsh -n ~/.zshrc
   ```

2. Verify template rendering:
   ```bash
   chezmoi diff
   ```

3. Re-apply clean config:
   ```bash
   chezmoi apply --force
   ```

## Git Issues

### GPG signing fails

**Symptoms:** `error: gpg failed to sign the data`

**Solutions:**

1. Check GPG agent:
   ```bash
   gpg --list-keys
   gpgconf --kill gpg-agent
   gpgconf --launch gpg-agent
   ```

2. Set GPG TTY:
   ```bash
   export GPG_TTY=$(tty)
   ```

3. Verify signing key:
   ```bash
   git config --global user.signingkey
   gpg --list-secret-keys --keyid-format=long
   ```

4. Test signing:
   ```bash
   echo "test" | gpg --clearsign
   ```

### SSH authentication fails

**Symptoms:** `Permission denied (publickey)`

**Solutions:**

1. Check SSH agent:
   ```bash
   ssh-add -l
   ```

2. Add key to agent:
   ```bash
   ssh-add ~/.ssh/id_ed25519
   ```

3. Verify key is on GitHub:
   ```bash
   ssh -T git@github.com
   ```

4. Check SSH config:
   ```bash
   cat ~/.ssh/config
   ```

## Chezmoi Issues

### Templates not rendering

**Symptoms:** Raw template syntax in output files

**Solutions:**

1. Check template syntax:
   ```bash
   chezmoi execute-template < home/dot_zshrc.tmpl
   ```

2. Verify data values:
   ```bash
   chezmoi data
   ```

3. Force re-apply:
   ```bash
   chezmoi apply --force -v
   ```

### Conflicts during apply

**Symptoms:** `chezmoi: would modify` warnings

**Solutions:**

1. View differences:
   ```bash
   chezmoi diff
   ```

2. Accept all source changes:
   ```bash
   chezmoi apply --force
   ```

3. Merge specific file:
   ```bash
   chezmoi merge ~/.zshrc
   ```

### External dependencies fail

**Symptoms:** External tool downloads fail during apply

**Solutions:**

1. Check network:
   ```bash
   curl -I https://github.com
   ```

2. Retry apply:
   ```bash
   chezmoi apply -v
   ```

3. Skip externals temporarily:
   ```bash
   chezmoi apply --exclude externals
   ```

## Homebrew Issues

### Bundle install fails

**Symptoms:** `brew bundle` errors out

**Solutions:**

1. Update Homebrew:
   ```bash
   brew update
   ```

2. Check for issues:
   ```bash
   brew doctor
   ```

3. Install packages individually to find problem:
   ```bash
   brew install package-name
   ```

4. Clean up:
   ```bash
   brew cleanup
   brew autoremove
   ```

### Cask installation fails

**Symptoms:** `Cask 'app-name' is unavailable`

**Solutions:**

1. Update cask list:
   ```bash
   brew update
   ```

2. Search for correct name:
   ```bash
   brew search app-name
   ```

3. Install from .dmg manually if cask unavailable

## Path Issues

### Wrong tool version used

**Symptoms:** Old version runs instead of expected

**Solutions:**

1. Check which version is found:
   ```bash
   which node  # or any tool
   type -a node
   ```

2. Verify PATH order:
   ```bash
   echo $PATH | tr ':' '\n' | head -10
   ```

3. Check version managers:
   ```bash
   asdf current
   asdf reshim
   ```

### PATH too long

**Symptoms:** Shell errors about argument list

**Solutions:**

1. Deduplicate PATH:
   ```bash
   export PATH=$(echo "$PATH" | tr ':' '\n' | awk '!seen[$0]++' | tr '\n' ':' | sed 's/:$//')
   ```

2. Review what's adding to PATH in shell configs

## Symlink Issues

### Broken symlinks

**Symptoms:** `No such file or directory` for config files

**Solutions:**

1. Find broken symlinks:
   ```bash
   find ~ -maxdepth 2 -type l ! -exec test -e {} \; -print
   ```

2. Verify dotfiles symlink:
   ```bash
   ls -la ~/dotfiles
   ```

3. Recreate symlink:
   ```bash
   rm ~/dotfiles
   ln -s /path/to/dotfiles ~/dotfiles
   ```

## Performance Issues

### Completion is slow

**Symptoms:** Tab completion takes seconds

**Solutions:**

1. Rebuild completion cache:
   ```bash
   rm -f ~/.zcompdump*
   compinit
   ```

2. Check completion files:
   ```bash
   ls ~/.zsh/completions/
   ```

3. Disable slow completions selectively

### Memory usage high

**Symptoms:** Shell uses excessive memory

**Solutions:**

1. Check loaded modules:
   ```bash
   zmodload
   ```

2. Disable history features:
   ```bash
   # In .zshrc
   HISTSIZE=10000  # Reduce from default
   ```

3. Disable unused plugins

## Getting Help

### Run health check

```bash
./scripts/health-check.sh
```

### Generate diagnostic info

```bash
echo "=== System ===" > diagnostic.txt
uname -a >> diagnostic.txt
echo "=== Shell ===" >> diagnostic.txt
echo $SHELL >> diagnostic.txt
zsh --version >> diagnostic.txt
echo "=== PATH ===" >> diagnostic.txt
echo $PATH >> diagnostic.txt
echo "=== Homebrew ===" >> diagnostic.txt
brew --version >> diagnostic.txt
brew doctor 2>&1 >> diagnostic.txt
```

### Report an issue

1. Run diagnostics above
2. Open issue at: https://github.com/thomasvincent/dotfiles/issues
3. Include:
   - macOS/Linux version
   - Error messages
   - Steps to reproduce
   - Diagnostic output
