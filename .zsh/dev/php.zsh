#!/usr/bin/env zsh
# php.zsh - PHP development environment configuration for macOS

# Ensure PHP tools are installed
if command -v php >/dev/null; then
  # PHP version info in prompt if using a project-specific version
  php_version() {
    emulate -L zsh
    if [[ -f "composer.json" ]]; then
      echo "(php:$(php -r 'echo PHP_VERSION;'))"
    fi
  }

  # PHP Composer path
  if [[ -d "$HOME/.composer/vendor/bin" ]]; then
    path=("$HOME/.composer/vendor/bin" $path)
  fi

  # Laravel shortcuts
  if command -v laravel >/dev/null || command -v artisan >/dev/null; then
    alias art="php artisan"
    alias tinker="php artisan tinker"
    alias lserve="php artisan serve"
    alias ltest="php artisan test"
    alias lmfs="php artisan migrate:fresh --seed"
  fi

  # Composer shortcuts
  if command -v composer >/dev/null; then
    alias c="composer"
    alias ci="composer install"
    alias cu="composer update"
    alias cr="composer require"
    alias cda="composer dump-autoload"
  fi

  # PHPCS and code quality
  if command -v phpcs >/dev/null; then
    alias phpcs="phpcs --standard=PSR12"
    alias phpcbf="phpcbf --standard=PSR12"
  fi

  # PHPUnit
  if command -v phpunit >/dev/null; then
    alias punit="phpunit"
    alias pcov="phpunit --coverage-html coverage"
  fi

  # PHP Project initializer (macOS optimized)
  php-init() {
    emulate -L zsh
    setopt local_options err_return

    local project_name="${1:-php-project}"
    if [[ -d "$project_name" ]]; then
      print -P "%F{red}Directory $project_name already exists%f"
      return 1
    fi

    print -P "%F{blue}Creating PHP project: %F{green}$project_name%f"

    # Use macOS-style command flags
    mkdir -p "$project_name"
    cd "$project_name" || return

    # Initialize composer
    print -P "%F{blue}Initializing Composer...%f"
    composer init --name="$USER/$project_name" --type=project --require="php:^8.0" --require-dev="phpunit/phpunit:^9.0" -n

    # Create basic structure
    print -P "%F{blue}Creating project structure...%f"
    mkdir -p src tests

    # Create gitignore with macOS specifics
    cat > .gitignore << 'EOL'
# PHP dependencies
/vendor/
/node_modules/
.env
.phpunit.result.cache
composer.lock
npm-debug.log
yarn-error.log

# IDE files
/.idea
/.vscode

# macOS specific
.DS_Store
.AppleDouble
.LSOverride
Icon
._*
.DocumentRevisions-V100
.fseventsd
.Spotlight-V100
.TemporaryItems
.Trashes
.VolumeIcon.icns
.com.apple.timemachine.donotpresent
EOL

    # Initialize git repo
    print -P "%F{blue}Initializing git repository...%f"
    git init -q

    print -P "%F{green}✓ PHP project initialized in %F{blue}$project_name%f"
  }
fi
