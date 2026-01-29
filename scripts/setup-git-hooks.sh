#!/bin/bash
# Setup script for git hooks
# Configures git to use the project's custom hooks directory
# Run this after cloning the repository

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}Setting up git hooks...${NC}"
echo ""

# Get the repository root directory
REPO_ROOT="$(git rev-parse --show-toplevel)"
HOOKS_DIR="$REPO_ROOT/hooks"

# Check if hooks directory exists
if [ ! -d "$HOOKS_DIR" ]; then
    echo -e "${RED}Error: hooks directory not found at $HOOKS_DIR${NC}"
    exit 1
fi

# Configure git to use custom hooks directory
echo -e "${YELLOW}Configuring git core.hooksPath...${NC}"
git config core.hooksPath hooks

# Make hooks executable
echo -e "${YELLOW}Making hooks executable...${NC}"
chmod +x "$HOOKS_DIR"/*

# Verify hooks are in place
echo -e "${YELLOW}Verifying hooks...${NC}"
for hook in pre-commit pre-push; do
    if [ -f "$HOOKS_DIR/$hook" ]; then
        echo -e "  ${GREEN}✓${NC} $hook"
    else
        echo -e "  ${RED}✗${NC} $hook not found"
        exit 1
    fi
done

echo ""
echo -e "${GREEN}✅ Git hooks installed successfully!${NC}"
echo ""
echo -e "${BLUE}Hooks installed:${NC}"
echo -e "  • ${GREEN}pre-commit${NC}: Validates workflows before committing"
echo -e "  • ${GREEN}pre-push${NC}: Validates workflows before pushing"
echo ""
echo -e "${BLUE}Requirements for full validation:${NC}"
echo -e "  Install shellcheck for shell script linting:"
echo -e "    ${YELLOW}brew install shellcheck${NC}           (macOS)"
echo -e "    ${YELLOW}sudo apt-get install shellcheck${NC}   (Ubuntu/Debian)"
echo -e "    ${YELLOW}pip install shellcheck-py${NC}        (pip)"
echo ""
echo -e "${BLUE}To bypass hooks if needed:${NC}"
echo -e "  ${YELLOW}git commit --no-verify${NC}  (skip pre-commit)"
echo -e "  ${YELLOW}git push --no-verify${NC}    (skip pre-push)"
echo ""
