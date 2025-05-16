#!/usr/bin/env zsh
# Node.js development environment setup

# === NVM (Node Version Manager) ===
# Setup NVM for Node.js version management
export NVM_DIR="$HOME/.nvm"
export NVM_LAZY_LOAD=true
export NVM_COMPLETION=true

# Load NVM using a deferred loading approach for faster shell startup
_nvm_init() {
  # Load NVM if installed via Homebrew
  if [[ -s "/usr/local/opt/nvm/nvm.sh" ]]; then
    source "/usr/local/opt/nvm/nvm.sh"
    source "/usr/local/opt/nvm/etc/bash_completion.d/nvm"
  # Load NVM if installed manually
  elif [[ -s "$NVM_DIR/nvm.sh" ]]; then
    source "$NVM_DIR/nvm.sh"
    [[ -s "$NVM_DIR/bash_completion" ]] && source "$NVM_DIR/bash_completion"
  else
    return 1
  fi
  return 0
}

# Create wrapper functions for lazy loading
nvm() {
  unfunction nvm node npm npx yarn pnpm
  _nvm_init
  nvm "$@"
}

node() {
  unfunction nvm node npm npx yarn pnpm
  _nvm_init
  node "$@"
}

npm() {
  unfunction nvm node npm npx yarn pnpm
  _nvm_init
  npm "$@"
}

npx() {
  unfunction nvm node npm npx yarn pnpm
  _nvm_init
  npx "$@"
}

yarn() {
  unfunction nvm node npm npx yarn pnpm
  _nvm_init
  yarn "$@"
}

pnpm() {
  unfunction nvm node npm npx yarn pnpm
  _nvm_init
  pnpm "$@"
}

# === Node.js Utilities ===
# Create a new Node.js project
create-node-project() {
  local project_name="$1"

  if [[ -z "$project_name" ]]; then
    echo "Usage: create-node-project <project-name>"
    return 1
  fi

  if [[ -d "$project_name" ]]; then
    echo "Directory $project_name already exists"
    return 1
  fi

  mkdir -p "$project_name"
  cd "$project_name" || return 1

  # Initialize package.json
  npm init -y

  # Create basic directory structure
  mkdir -p src test

  # Create basic files
  echo 'console.log("Hello, world!");' > src/index.js
  echo 'module.exports = {};' > src/main.js
  echo '# Project: '"$project_name"'\n\nA Node.js project.' > README.md
  echo 'node_modules\n.env\n.DS_Store\ncoverage\n.nyc_output\ndist' > .gitignore

  # Add commonly used dependencies
  npm install --save-dev nodemon eslint jest

  # Add scripts to package.json
  npm pkg set scripts.start="node src/index.js"
  npm pkg set scripts.dev="nodemon src/index.js"
  npm pkg set scripts.test="jest"
  npm pkg set scripts.lint="eslint ."

  # Initialize git repository
  git init
  git add .
  git commit -m "Initial commit"

  echo "Node.js project $project_name created successfully"
  echo "Run 'npm run dev' to start development server"
}

# Install global packages I commonly use
node-globals() {
  echo "Installing common global Node.js packages..."

  # Make sure NVM is loaded
  _nvm_init > /dev/null

  npm install -g npm
  npm install -g typescript
  npm install -g ts-node
  npm install -g nodemon
  npm install -g eslint
  npm install -g http-server
  npm install -g json-server
  npm install -g npm-check-updates

  echo "Global packages installed successfully"
}

# Update all outdated npm packages in the current project
npm-update-all() {
  if [[ ! -f "package.json" ]]; then
    echo "No package.json found in current directory"
    return 1
  fi

  echo "Updating all npm packages..."

  # Check if npm-check-updates is installed
  if ! command -v ncu &> /dev/null; then
    echo "Installing npm-check-updates..."
    npm install -g npm-check-updates
  fi

  # Update dependencies
  ncu -u
  npm install

  echo "All packages updated successfully"
}

# Run security audit
npm-audit-fix() {
  if [[ ! -f "package.json" ]]; then
    echo "No package.json found in current directory"
    return 1
  fi

  echo "Running npm audit and fixing vulnerabilities..."
  npm audit fix
}

# List all node_modules sizes
npm-size() {
  if command -v ncdu &> /dev/null; then
    ncdu ./node_modules
  else
    du -sh ./node_modules/* | sort -hr
  fi
}

# Clean up node_modules and reinstall
npm-clean-install() {
  if [[ ! -f "package.json" ]]; then
    echo "No package.json found in current directory"
    return 1
  fi

  echo "Cleaning node_modules and reinstalling..."
  rm -rf node_modules
  rm -f package-lock.json
  npm install

  echo "Clean install completed"
}
