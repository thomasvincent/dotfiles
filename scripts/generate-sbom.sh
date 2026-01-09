#!/bin/bash
# generate-sbom.sh - Generate Software Bill of Materials from Brewfiles
#
# Generates SBOM in CycloneDX JSON format (default) or SPDX JSON format.
# Parses all Brewfiles to extract package dependencies.
#
# Usage:
#   ./scripts/generate-sbom.sh [options]
#
# Options:
#   -f, --format FORMAT   Output format: cyclonedx (default) or spdx
#   -o, --output FILE     Output file (default: sbom.json)
#   -h, --help            Show this help message
#
# Example:
#   ./scripts/generate-sbom.sh -f cyclonedx -o sbom-cyclonedx.json
#   ./scripts/generate-sbom.sh -f spdx -o sbom-spdx.json

set -euo pipefail

# Defaults
FORMAT="cyclonedx"
OUTPUT="sbom.json"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
RESET='\033[0m'

# Help message
show_help() {
    sed -n '2,17p' "$0" | sed 's/^# //' | sed 's/^#//'
    exit 0
}

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -f|--format)
            FORMAT="$2"
            shift 2
            ;;
        -o|--output)
            OUTPUT="$2"
            shift 2
            ;;
        -h|--help)
            show_help
            ;;
        *)
            echo -e "${RED}Unknown option: $1${RESET}"
            exit 1
            ;;
    esac
done

# Validate format
if [[ "$FORMAT" != "cyclonedx" && "$FORMAT" != "spdx" ]]; then
    echo -e "${RED}Invalid format: $FORMAT. Use 'cyclonedx' or 'spdx'${RESET}"
    exit 1
fi

echo -e "${BLUE}Generating SBOM in ${FORMAT} format...${RESET}"

# Arrays to hold packages
declare -a BREW_PACKAGES=()
declare -a CASK_PACKAGES=()
declare -a TAP_PACKAGES=()

# Parse a Brewfile
parse_brewfile() {
    local file="$1"
    if [[ ! -f "$file" ]]; then
        return
    fi

    echo -e "${YELLOW}Parsing: $file${RESET}"

    while IFS= read -r line || [[ -n "$line" ]]; do
        # Skip comments and empty lines
        [[ "$line" =~ ^[[:space:]]*# ]] && continue
        [[ -z "${line// }" ]] && continue

        # Extract package type and name
        if [[ "$line" =~ ^brew[[:space:]]+[\"\']([^\"\']+)[\"\'] ]]; then
            BREW_PACKAGES+=("${BASH_REMATCH[1]}")
        elif [[ "$line" =~ ^cask[[:space:]]+[\"\']([^\"\']+)[\"\'] ]]; then
            CASK_PACKAGES+=("${BASH_REMATCH[1]}")
        elif [[ "$line" =~ ^tap[[:space:]]+[\"\']([^\"\']+)[\"\'] ]]; then
            TAP_PACKAGES+=("${BASH_REMATCH[1]}")
        fi
    done < "$file"
}

# Parse all Brewfiles
for brewfile in "$DOTFILES_DIR"/Brewfile*; do
    parse_brewfile "$brewfile"
done

# Get timestamp
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
UUID=$(uuidgen 2>/dev/null || cat /proc/sys/kernel/random/uuid 2>/dev/null || echo "$(date +%s)-$(( RANDOM ))")

# Generate CycloneDX format
generate_cyclonedx() {
    local output_file="$1"

    cat > "$output_file" << EOF
{
  "bomFormat": "CycloneDX",
  "specVersion": "1.5",
  "serialNumber": "urn:uuid:${UUID}",
  "version": 1,
  "metadata": {
    "timestamp": "${TIMESTAMP}",
    "tools": [
      {
        "vendor": "dotfiles",
        "name": "generate-sbom.sh",
        "version": "1.0.0"
      }
    ],
    "component": {
      "type": "application",
      "name": "dotfiles",
      "version": "1.0.0",
      "description": "Personal dotfiles configuration",
      "licenses": [
        {
          "license": {
            "id": "MIT"
          }
        }
      ],
      "purl": "pkg:github/thomasvincent/dotfiles"
    }
  },
  "components": [
EOF

    local first=true

    # Add brew packages
    for pkg in "${BREW_PACKAGES[@]}"; do
        if [[ "$first" == "true" ]]; then
            first=false
        else
            echo "," >> "$output_file"
        fi
        cat >> "$output_file" << EOF
    {
      "type": "application",
      "name": "${pkg}",
      "purl": "pkg:brew/${pkg}",
      "properties": [
        {
          "name": "package:type",
          "value": "homebrew-formula"
        }
      ]
    }
EOF
    done

    # Add cask packages
    for pkg in "${CASK_PACKAGES[@]}"; do
        if [[ "$first" == "true" ]]; then
            first=false
        else
            echo "," >> "$output_file"
        fi
        cat >> "$output_file" << EOF
    {
      "type": "application",
      "name": "${pkg}",
      "purl": "pkg:brew/${pkg}?type=cask",
      "properties": [
        {
          "name": "package:type",
          "value": "homebrew-cask"
        }
      ]
    }
EOF
    done

    cat >> "$output_file" << EOF

  ]
}
EOF
}

# Generate SPDX format
generate_spdx() {
    local output_file="$1"
    local doc_namespace="https://github.com/thomasvincent/dotfiles/sbom-${UUID}"

    cat > "$output_file" << EOF
{
  "spdxVersion": "SPDX-2.3",
  "dataLicense": "CC0-1.0",
  "SPDXID": "SPDXRef-DOCUMENT",
  "name": "dotfiles-sbom",
  "documentNamespace": "${doc_namespace}",
  "creationInfo": {
    "created": "${TIMESTAMP}",
    "creators": [
      "Tool: generate-sbom.sh-1.0.0"
    ]
  },
  "packages": [
    {
      "SPDXID": "SPDXRef-Package-dotfiles",
      "name": "dotfiles",
      "versionInfo": "1.0.0",
      "downloadLocation": "https://github.com/thomasvincent/dotfiles",
      "filesAnalyzed": false,
      "licenseConcluded": "MIT",
      "licenseDeclared": "MIT",
      "copyrightText": "NOASSERTION",
      "description": "Personal dotfiles configuration"
    }
EOF

    local counter=1

    # Add brew packages
    for pkg in "${BREW_PACKAGES[@]}"; do
        cat >> "$output_file" << EOF
,
    {
      "SPDXID": "SPDXRef-Package-brew-${counter}",
      "name": "${pkg}",
      "versionInfo": "NOASSERTION",
      "downloadLocation": "https://formulae.brew.sh/formula/${pkg}",
      "filesAnalyzed": false,
      "licenseConcluded": "NOASSERTION",
      "licenseDeclared": "NOASSERTION",
      "copyrightText": "NOASSERTION",
      "externalRefs": [
        {
          "referenceCategory": "PACKAGE-MANAGER",
          "referenceType": "purl",
          "referenceLocator": "pkg:brew/${pkg}"
        }
      ]
    }
EOF
        ((counter++))
    done

    # Add cask packages
    for pkg in "${CASK_PACKAGES[@]}"; do
        cat >> "$output_file" << EOF
,
    {
      "SPDXID": "SPDXRef-Package-cask-${counter}",
      "name": "${pkg}",
      "versionInfo": "NOASSERTION",
      "downloadLocation": "https://formulae.brew.sh/cask/${pkg}",
      "filesAnalyzed": false,
      "licenseConcluded": "NOASSERTION",
      "licenseDeclared": "NOASSERTION",
      "copyrightText": "NOASSERTION",
      "externalRefs": [
        {
          "referenceCategory": "PACKAGE-MANAGER",
          "referenceType": "purl",
          "referenceLocator": "pkg:brew/${pkg}?type=cask"
        }
      ]
    }
EOF
        ((counter++))
    done

    cat >> "$output_file" << EOF

  ],
  "relationships": [
EOF

    first=true
    counter=1

    # Add relationships for brew packages
    for pkg in "${BREW_PACKAGES[@]}"; do
        if [[ "$first" == "true" ]]; then
            first=false
        else
            echo "," >> "$output_file"
        fi
        cat >> "$output_file" << EOF
    {
      "spdxElementId": "SPDXRef-Package-dotfiles",
      "relatedSpdxElement": "SPDXRef-Package-brew-${counter}",
      "relationshipType": "DEPENDS_ON"
    }
EOF
        ((counter++))
    done

    # Add relationships for cask packages
    for pkg in "${CASK_PACKAGES[@]}"; do
        if [[ "$first" == "true" ]]; then
            first=false
        else
            echo "," >> "$output_file"
        fi
        cat >> "$output_file" << EOF
    {
      "spdxElementId": "SPDXRef-Package-dotfiles",
      "relatedSpdxElement": "SPDXRef-Package-cask-${counter}",
      "relationshipType": "DEPENDS_ON"
    }
EOF
        ((counter++))
    done

    cat >> "$output_file" << EOF

  ]
}
EOF
}

# Generate SBOM
if [[ "$FORMAT" == "cyclonedx" ]]; then
    generate_cyclonedx "$OUTPUT"
else
    generate_spdx "$OUTPUT"
fi

# Summary
echo -e "${GREEN}SBOM generated successfully!${RESET}"
echo -e "  Format: ${FORMAT}"
echo -e "  Output: ${OUTPUT}"
echo -e "  Packages:"
echo -e "    - Homebrew formulas: ${#BREW_PACKAGES[@]}"
echo -e "    - Homebrew casks: ${#CASK_PACKAGES[@]}"
echo -e "    - Taps: ${#TAP_PACKAGES[@]}"
echo -e "  Total components: $((${#BREW_PACKAGES[@]} + ${#CASK_PACKAGES[@]}))"
