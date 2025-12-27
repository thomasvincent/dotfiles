# Tests

This directory contains tests for the dotfiles configuration.

## Running Tests

### All Tests (via Make)

```bash
make test
```

### Individual Tests

```bash
# Platform detection
zsh tests/test_platform.zsh

# Shell startup
bash tests/test_shell_startup.sh
```

## Test Descriptions

| Test | Purpose |
|------|--------|
| `test_platform.zsh` | Verify platform detection (macOS vs Linux) |
| `test_shell_startup.sh` | Ensure shell starts without errors |

## CI/CD Integration

These tests run automatically via GitHub Actions on every push.
See `.github/workflows/ci.yml` for configuration.
