# Git Hooks

This directory contains git hooks that automatically validate the repository before commits and pushes.

## Available Hooks

### pre-commit
**Runs before:** `git commit`
**Purpose:** Validates YAML workflow files before committing changes

**What it does:**
- Runs `./scripts/validate-yaml.sh`
- Checks all GitHub Actions workflows for syntax errors
- Runs shellcheck on embedded shell scripts (if shellcheck is installed)

**If validation fails:**
- Commit is blocked
- Error message shows what needs to be fixed
- Fix the issues and try committing again

### pre-push
**Runs before:** `git push`
**Purpose:** Final validation check before pushing to remote

**What it does:**
- Runs `./scripts/validate-yaml.sh`
- Same checks as pre-commit as a safety net

**If validation fails:**
- Push is blocked
- Error message shows what needs to be fixed

## Installation

To install these hooks, run the setup script after cloning:

```bash
./scripts/setup-git-hooks.sh
```

This will:
1. Configure git to use this directory for hooks
2. Make all hook scripts executable
3. Verify hooks are in place

## Requirements

For full validation including shellcheck:
```bash
# Install shellcheck (required for shell script linting)
brew install shellcheck          # macOS
sudo apt-get install shellcheck  # Ubuntu/Debian
pip install shellcheck-py        # pip
```

Without shellcheck, actionlint still validates YAML structure but skips shell script linting.

## Bypassing Hooks

If you need to bypass hooks (not recommended):
```bash
# Skip pre-commit hook
git commit --no-verify

# Skip pre-push hook
git push --no-verify
```

## Troubleshooting

**"Permission denied" error:**
```bash
chmod +x hooks/pre-commit hooks/pre-push
```

**"shellcheck: command not found"**
- Install shellcheck (see Requirements above)
- Hooks will still work but with reduced validation

**Hook not running:**
- Run setup script again: `./scripts/setup-git-hooks.sh`
- Verify git config: `git config core.hooksPath`
- Should output: `hooks`

**git config not persisting:**
Git stores hook path in `.git/config` (local, not committed). This is normal.
If you need to reinstall after cloning, just run `./scripts/setup-git-hooks.sh` again.
