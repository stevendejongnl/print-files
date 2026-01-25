#!/bin/bash

# Install Git Hooks for print-files repository

set -e

echo "🔧 Installing Git hooks..."

# Create .git/hooks directory if it doesn't exist
mkdir -p .git/hooks

# Install pre-commit hook
if [ -f ".git/hooks/pre-commit" ]; then
    echo "⚠️  Warning: pre-commit hook already exists"
    read -p "   Overwrite? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "❌ Installation cancelled"
        exit 1
    fi
fi

# Copy pre-commit hook
cp scripts/hooks/pre-commit .git/hooks/pre-commit
chmod +x .git/hooks/pre-commit

echo "✅ Pre-commit hook installed successfully"
echo ""
echo "The hook will:"
echo "  • Validate YAML files in .github/workflows/ before commit"
echo "  • Prevent commits with invalid YAML syntax"
echo ""
echo "To test the hook, try committing a YAML file."
echo "To bypass the hook (not recommended), use: git commit --no-verify"
