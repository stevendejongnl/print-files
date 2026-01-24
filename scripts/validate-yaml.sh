#!/bin/bash

# YAML Validation Script
# Validates YAML files in .github/workflows/ directory

set -e

echo "🔍 Validating YAML workflow files..."

has_errors=false

# Use actionlint if available (best option for GitHub Actions)
if command -v actionlint &> /dev/null; then
    echo "Using actionlint for validation"
    if actionlint .github/workflows/*.yml; then
        echo "✅ All workflow files are valid (actionlint)"
        exit 0
    else
        echo "❌ Workflow validation failed"
        exit 1
    fi
fi

# Fallback: Check with yamllint if available
if command -v yamllint &> /dev/null; then
    echo "Using yamllint for validation"
    if yamllint -d "{extends: default, rules: {line-length: disable, document-start: disable}}" .github/workflows/*.yml; then
        echo "✅ All YAML files are valid (yamllint)"
        exit 0
    else
        echo "❌ YAML validation failed"
        exit 1
    fi
fi

# Fallback: Basic Python YAML check
if command -v python3 &> /dev/null; then
    echo "Using Python for basic YAML validation"

    for file in .github/workflows/*.yml; do
        if python3 -c "
import yaml
import sys
try:
    with open('$file', 'r') as f:
        # Try to load as YAML
        try:
            data = yaml.safe_load(f)
        except:
            # If safe_load fails due to anchors/aliases, try FullLoader
            f.seek(0)
            data = yaml.load(f, Loader=yaml.FullLoader)

        # Check for required GitHub Actions fields
        if not isinstance(data, dict):
            print('ERROR: Root must be a dictionary')
            sys.exit(1)
        if 'name' not in data:
            print('ERROR: Missing required field: name')
            sys.exit(1)
        if 'on' not in data:
            print('ERROR: Missing required field: on')
            sys.exit(1)
        if 'jobs' not in data:
            print('ERROR: Missing required field: jobs')
            sys.exit(1)
    print('  ✓ $file')
    sys.exit(0)
except yaml.YAMLError as e:
    print('  ✗ $file')
    print(f'YAML Error: {e}')
    sys.exit(1)
except Exception as e:
    print('  ✗ $file')
    print(f'Error: {e}')
    sys.exit(1)
"; then
            echo "  ✓ $file"
        else
            echo "  ✗ $file - validation failed"
            has_errors=true
        fi
    done

    if [ "$has_errors" = true ]; then
        echo ""
        echo "❌ YAML validation failed!"
        echo ""
        echo "Tips:"
        echo "  • Check indentation (use spaces, not tabs)"
        echo "  • Ensure proper quoting of strings with special characters"
        echo "  • Install actionlint for better validation: brew install actionlint"
        exit 1
    else
        echo ""
        echo "✅ All YAML files passed basic validation"
        echo ""
        echo "Note: Install actionlint for comprehensive GitHub Actions validation:"
        echo "  macOS: brew install actionlint"
        echo "  Linux: https://github.com/rhysd/actionlint"
        exit 0
    fi
fi

# If no tools available, warn but don't fail
echo "⚠️  Warning: No YAML validator found"
echo ""
echo "Please install one of the following:"
echo "  • actionlint (recommended): brew install actionlint"
echo "  • yamllint: pip install yamllint"
echo "  • python3 with PyYAML: pip install pyyaml"
echo ""
echo "Skipping validation..."
exit 0
