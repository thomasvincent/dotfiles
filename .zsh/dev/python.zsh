#!/usr/bin/env zsh
# Python development environment setup

# === Pyenv (Python Version Manager) ===
# Setup pyenv for Python version management
if command -v pyenv &> /dev/null; then
  export PYENV_ROOT="$HOME/.pyenv"
  [[ -d $PYENV_ROOT/bin ]] && path=($PYENV_ROOT/bin $path)
  eval "$(pyenv init -)"

  # Enable pyenv-virtualenv if installed
  if command -v pyenv-virtualenv-init &> /dev/null; then
    eval "$(pyenv virtualenv-init -)"
  fi
fi

# === Python Utilities ===
# Create a new Python project with virtual environment
create-python-project() {
  local project_name="$1"
  local python_version="${2:-3}"

  if [[ -z "$project_name" ]]; then
    echo "Usage: create-python-project <project-name> [python-version]"
    return 1
  fi

  if [[ -d "$project_name" ]]; then
    echo "Directory $project_name already exists"
    return 1
  fi

  mkdir -p "$project_name"
  cd "$project_name" || return 1

  # Create virtual environment
  python$python_version -m venv .venv

  # Activate virtual environment
  source .venv/bin/activate

  # Create basic directory structure
  mkdir -p src tests docs

  # Create basic files
  echo "# $project_name\n\nA Python project." > README.md
  echo '*.pyc\n__pycache__/\n.venv/\n.env\n.DS_Store\n.coverage\nhtml/\ndist/\n*.egg-info/\n.pytest_cache/\n.ipynb_checkpoints/' > .gitignore

  # Create package structure
  mkdir -p "src/$project_name"
  touch "src/$project_name/__init__.py"
  echo "def main():\n    print(\"Hello, world!\")\n\nif __name__ == \"__main__\":\n    main()" > "src/$project_name/main.py"

  # Create setup.py
  cat > setup.py << EOF
from setuptools import setup, find_packages

setup(
    name="$project_name",
    version="0.1.0",
    packages=find_packages(where="src"),
    package_dir={"": "src"},
    python_requires=">=3.6",
    install_requires=[],
    author="Your Name",
    author_email="your.email@example.com",
    description="A Python project",
    keywords="$project_name",
    url="https://github.com/yourusername/$project_name",
)
EOF

  # Create a test file
  cat > "tests/test_main.py" << EOF
from $project_name.main import main

def test_main():
    # Just a placeholder test
    assert callable(main)
EOF

  # Install development tools
  pip install --upgrade pip
  pip install pytest pytest-cov black isort flake8 mypy pylint

  # Create requirements files
  pip freeze > requirements.txt

  # Create a requirements-dev.txt file
  cat > requirements-dev.txt << EOF
pytest
pytest-cov
black
isort
flake8
mypy
pylint
EOF

  # Initialize git repository
  git init
  git add .
  git commit -m "Initial commit"

  echo "Python project $project_name created successfully with Python $python_version"
  echo "Virtual environment is active. Use 'deactivate' to exit."
}

# Set up a simple Python webserver in the current directory
function pyserver() {
  local port=${1:-8000}
  echo "Starting Python HTTP server on port $port..."
  python -m http.server "$port"
}

# Generate requirements.txt from the current environment
pyfreezeenv() {
  if [[ -f "requirements.txt" ]]; then
    echo "requirements.txt already exists. Overwrite? (y/n)"
    read -q response
    echo
    if [[ "$response" != "y" ]]; then
      return 1
    fi
  fi

  # If in a virtual environment, use pip freeze
  if [[ -n "$VIRTUAL_ENV" ]]; then
    pip freeze > requirements.txt
    echo "Generated requirements.txt from current virtual environment"
  else
    echo "Not in a virtual environment. Continue? (y/n)"
    read -q response
    echo
    if [[ "$response" == "y" ]]; then
      pip freeze > requirements.txt
      echo "Generated requirements.txt (warning: not in a virtual environment)"
    fi
  fi
}

# Install all requirements from requirements.txt
pyinstallreq() {
  if [[ ! -f "requirements.txt" ]]; then
    echo "No requirements.txt found in current directory"
    return 1
  fi

  # Check if we're in a virtual environment
  if [[ -z "$VIRTUAL_ENV" ]]; then
    echo "Not in a virtual environment. Continue? (y/n)"
    read -q response
    echo
    if [[ "$response" != "y" ]]; then
      return 1
    fi
  fi

  pip install -r requirements.txt
}

# Create and activate a virtual environment
pyvenv() {
  local env_name="${1:-.venv}"
  local python_version="${2:-3}"

  # Check if the environment already exists
  if [[ -d "$env_name" ]]; then
    echo "Virtual environment $env_name already exists"
    echo "Activate with: source $env_name/bin/activate"
    return 0
  fi

  # Create virtual environment
  python$python_version -m venv "$env_name"

  # Activate it
  source "$env_name/bin/activate"

  # Upgrade pip
  pip install --upgrade pip

  echo "Virtual environment $env_name created and activated"
  echo "Deactivate with: deactivate"
}

# Run a code formatter on Python files
pyformat() {
  # Check for black and isort
  if ! command -v black &> /dev/null; then
    echo "black not found. Install? (y/n)"
    read -q response
    echo
    if [[ "$response" == "y" ]]; then
      pip install black
    else
      return 1
    fi
  fi

  if ! command -v isort &> /dev/null; then
    echo "isort not found. Install? (y/n)"
    read -q response
    echo
    if [[ "$response" == "y" ]]; then
      pip install isort
    else
      return 1
    fi
  fi

  local target="${1:-.}"

  echo "Formatting Python code in $target..."
  isort "$target"
  black "$target"

  echo "Formatting complete"
}

# Run lint checks
pylint() {
  local target="${1:-.}"

  if ! command -v flake8 &> /dev/null; then
    echo "flake8 not found. Install? (y/n)"
    read -q response
    echo
    if [[ "$response" == "y" ]]; then
      pip install flake8
    else
      return 1
    fi
  fi

  echo "Running lint checks on $target..."
  flake8 "$target"
}

# Run type checks with mypy
pytype() {
  local target="${1:-.}"

  if ! command -v mypy &> /dev/null; then
    echo "mypy not found. Install? (y/n)"
    read -q response
    echo
    if [[ "$response" == "y" ]]; then
      pip install mypy
    else
      return 1
    fi
  fi

  echo "Running type checks on $target..."
  mypy "$target"
}
