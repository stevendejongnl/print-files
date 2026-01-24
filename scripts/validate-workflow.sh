#!/bin/bash

# ============================================================
# Validate GitHub Actions workflows before committing
# ============================================================
# This script validates YAML syntax and bash scripts in workflows
# Usage: ./scripts/validate-workflow.sh [workflow-file]
# ============================================================

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}GitHub Actions Workflow Validator${NC}"
echo ""

# Check if a specific workflow file is provided
if [ $# -eq 0 ]; then
    # Validate all workflow files
    workflow_files=$(find .github/workflows -name "*.yml" -o -name "*.yaml" 2>/dev/null || true)
    if [ -z "$workflow_files" ]; then
        echo -e "${YELLOW}No workflow files found${NC}"
        exit 0
    fi
else
    workflow_files="$@"
fi

# Track validation status
all_valid=true

# Process each workflow file
for workflow_file in $workflow_files; do
    if [ ! -f "$workflow_file" ]; then
        echo -e "${RED}✗ File not found: $workflow_file${NC}"
        all_valid=false
        continue
    fi

    echo -e "${BLUE}Validating: $workflow_file${NC}"

    # 1. Check YAML syntax with Python
    echo -n "  YAML syntax... "
    if python3 -c "import yaml; yaml.safe_load(open('$workflow_file'))" 2>/dev/null; then
        echo -e "${GREEN}✓${NC}"
    else
        echo -e "${RED}✗ Invalid YAML syntax${NC}"
        python3 -c "import yaml; yaml.safe_load(open('$workflow_file'))" 2>&1 || true
        all_valid=false
        continue
    fi

    # 2. Check for required fields
    echo -n "  Required fields... "
    has_name=$(grep -q "^name:" "$workflow_file" && echo "true" || echo "false")
    has_on=$(grep -q "^on:" "$workflow_file" && echo "true" || echo "false")
    has_jobs=$(grep -q "^jobs:" "$workflow_file" && echo "true" || echo "false")

    if [ "$has_name" = "true" ] && [ "$has_on" = "true" ] && [ "$has_jobs" = "true" ]; then
        echo -e "${GREEN}✓${NC}"
    else
        echo -e "${RED}✗ Missing required fields (name, on, jobs)${NC}"
        all_valid=false
        continue
    fi

    # 3. Check for common issues
    echo -n "  Common issues... "
    issues=()

    # Check for tabs (YAML should use spaces)
    if grep -q $'\t' "$workflow_file"; then
        issues+=("Contains tabs (use spaces)")
    fi

    # Check for trailing whitespace
    if grep -q " $" "$workflow_file"; then
        issues+=("Contains trailing whitespace")
    fi

    # Check permissions block if pushing
    if grep -q "git push" "$workflow_file"; then
        if ! grep -q "^permissions:" "$workflow_file"; then
            issues+=("Missing 'permissions' block (needed for git push)")
        fi
    fi

    if [ ${#issues[@]} -eq 0 ]; then
        echo -e "${GREEN}✓${NC}"
    else
        echo -e "${YELLOW}⚠ Warnings:${NC}"
        for issue in "${issues[@]}"; do
            echo -e "    ${YELLOW}- $issue${NC}"
        done
    fi

    # 4. Extract and validate bash scripts
    echo -n "  Bash scripts... "
    bash_scripts=$(mktemp)

    # Extract run: blocks (simplified - won't handle all cases)
    awk '/run: \|/{flag=1; next} /^[^ ]/{flag=0} flag' "$workflow_file" > "$bash_scripts"

    if [ -s "$bash_scripts" ]; then
        if bash -n "$bash_scripts" 2>/dev/null; then
            echo -e "${GREEN}✓${NC}"
        else
            echo -e "${YELLOW}⚠ Bash syntax warnings${NC}"
            bash -n "$bash_scripts" 2>&1 | head -5 || true
        fi
    else
        echo -e "${BLUE}(none)${NC}"
    fi
    rm -f "$bash_scripts"

    # 5. Check for actionlint if available
    if command -v actionlint &> /dev/null; then
        echo -n "  GitHub Actions linting... "
        if actionlint "$workflow_file" 2>&1 | grep -q "no errors"; then
            echo -e "${GREEN}✓${NC}"
        else
            echo -e "${YELLOW}⚠ Linting warnings:${NC}"
            actionlint "$workflow_file" 2>&1 | head -10 || true
        fi
    fi

    echo ""
done

# Final status
if [ "$all_valid" = true ]; then
    echo -e "${GREEN}✓ All workflows validated successfully${NC}"
    exit 0
else
    echo -e "${RED}✗ Some workflows have issues${NC}"
    exit 1
fi
