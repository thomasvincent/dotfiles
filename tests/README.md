# Tests

Automated tests using [bats-core](https://github.com/bats-core/bats-core).

## Prerequisites

```bash
brew install bats-core    # macOS
sudo apt install bats     # Ubuntu/Debian
```

## Running Tests

```bash
make test                 # Full suite
make test-quick           # Syntax + config only
bats tests/shell_syntax.bats  # Single file
```

## Test Files

| File | Purpose |
|------|---------|
| `shell_syntax.bats` | Validates all `.zsh.tmpl` files pass `zsh -n` after template stripping |
| `duplicate_functions.bats` | Detects duplicate function names across modules |
| `config_validation.bats` | Validates TOML/YAML configs with Python |
| `template_syntax.bats` | Checks balanced `{{ }}` braces and if/end blocks |
| `shell_startup.bats` | Tests zsh interactive startup (skipped if not applied) |
| `shellcheck.bats` | Runs shellcheck on chezmoi-rendered templates |
| `chezmoi_templates.bats` | Renders all templates against 3 config profiles |
| `function_behavior.bats` | Tests pure zsh functions (mkd, extract, etc.) |

## Fixtures

Test config profiles in `fixtures/`:

| Profile | File | Description |
|---------|------|-------------|
| Minimal | `chezmoi-minimal.toml` | All features disabled, Linux target |
| Personal | `chezmoi-personal.toml` | macOS, GTD, cloud, dev tools enabled |
| Work | `chezmoi-work.toml` | Enterprise focus, Azure/AWS, Microsoft GTD |

Fixtures use the nested TOML structure (`[data.cloud]`, `[data.preferences]`, `[data.security]`) matching the real `chezmoi.toml`.

## Test Helpers

`test_helper/common-setup.bash` provides:

- `REPO_DIR`, `HOME_DIR`, `ZSH_DIR` — path variables
- `strip_template_markers <file>` — removes `{{ }}` syntax, producing valid shell for linting
- `render_template <file> [config]` — renders a template via `chezmoi execute-template`
- `setup()` / `teardown()` — temp directory lifecycle

## Adding Tests

1. Create `tests/your_test.bats`
2. Add `load test_helper/common-setup` at the top
3. Write `@test "description" { ... }` blocks
4. Use `skip "reason"` for conditional tests
5. Run `bats tests/your_test.bats` to verify
