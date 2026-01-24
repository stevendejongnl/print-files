# Scripts Directory

This directory contains automation scripts for working with OpenSCAD files in this repository.

## generate-exports.sh

Automatically generates STL and PNG files from OpenSCAD (.scad) source files.

### Prerequisites

OpenSCAD must be installed on your system:

- **macOS:** `brew install openscad`
- **Ubuntu/Debian:** `sudo apt-get install openscad`
- **Windows:** Download from [openscad.org](https://openscad.org/downloads.html)

### Usage

**Process all .scad files in the repository:**
```bash
./scripts/generate-exports.sh
```

**Process specific file(s):**
```bash
./scripts/generate-exports.sh spigen-pd2101-mount/spigen-pd2101-mount.scad
./scripts/generate-exports.sh file1.scad file2.scad
```

### Output

For each `.scad` file, the script generates:

1. **STL file** - Binary 3D model ready for slicing and printing
2. **PNG file** - 1024x768 preview image with axes and scale

Files are created in the same directory as the source `.scad` file.

### Example

```bash
$ ./scripts/generate-exports.sh spigen-pd2101-mount/spigen-pd2101-mount.scad

Processing: spigen-pd2101-mount/spigen-pd2101-mount.scad
  Generating STL: spigen-pd2101-mount/spigen-pd2101-mount.stl
  ✓ STL generated successfully
  -rw-r--r-- 1 user user 84K Jan 24 10:30 spigen-pd2101-mount/spigen-pd2101-mount.stl
  Generating PNG: spigen-pd2101-mount/spigen-pd2101-mount.png
  ✓ PNG generated successfully
  -rw-r--r-- 1 user user 45K Jan 24 10:30 spigen-pd2101-mount/spigen-pd2101-mount.png

✓ All files processed
```

### PNG Preview Settings

The generated PNG previews use these OpenSCAD settings:

- **Size:** 1024x768 pixels
- **View:** Orthographic projection with axes and scales
- **Color scheme:** Tomorrow (modern, readable)
- **Camera:** Angled view at 60° rotation, 25° tilt, 500mm distance

You can customize these settings by editing the script's `openscad` command parameters.

## GitHub Actions Automation

This repository also includes a GitHub Actions workflow that automatically:

1. Detects when `.scad` files are pushed to the repository
2. Generates STL and PNG files using the same logic
3. Commits and pushes the generated files back to the repository

**Location:** `.github/workflows/generate-stl-png.yml`

**Triggers:**
- Automatically on push of any `.scad` file
- Manually via "Actions" tab → "Generate STL and PNG from SCAD files" → "Run workflow"

**Benefits:**
- No need to manually generate exports before committing
- Ensures STL and PNG files are always up-to-date
- Works on any platform (no local OpenSCAD installation needed for contributors)

### Manual Trigger

1. Go to the "Actions" tab in GitHub
2. Select "Generate STL and PNG from SCAD files"
3. Click "Run workflow"
4. Choose the branch and click "Run workflow"

The workflow will process all `.scad` files and commit the results.

---

## validate-yaml.sh

Validates YAML files in `.github/workflows/` to catch syntax errors before committing.

### Prerequisites

One of the following:
- **yamllint:** `pip install yamllint` (recommended)
- **Python 3 with PyYAML:** `pip install pyyaml`

If neither is available, the script will warn but not fail.

### Usage

**Validate all workflow files:**
```bash
./scripts/validate-yaml.sh
```

### What It Checks

- YAML syntax validation
- Proper structure and formatting
- Catches common errors like:
  - Invalid indentation
  - Missing colons
  - Unclosed quotes
  - Invalid characters

### Example Output

```bash
$ ./scripts/validate-yaml.sh

🔍 Validating YAML files...
Using Python for validation
  ✓ .github/workflows/generate-stl-png.yml
  ✓ .github/workflows/sync-web-gallery.yml

✅ All YAML files are valid
```

---

## install-hooks.sh

Installs Git pre-commit hooks to automatically validate YAML files before each commit.

### Usage

**One-time installation:**
```bash
./scripts/install-hooks.sh
```

This will:
1. Copy the pre-commit hook to `.git/hooks/`
2. Make it executable
3. Configure automatic YAML validation

### What the Hook Does

When you commit changes to workflow files, the hook will:
1. Detect YAML files in `.github/workflows/`
2. Automatically run `validate-yaml.sh`
3. Block the commit if validation fails
4. Show clear error messages

### Example

```bash
$ git add .github/workflows/sync-web-gallery.yml
$ git commit -m "Update workflow"

📋 YAML files detected in commit, running validation...
🔍 Validating YAML files...
Using Python for validation
  ✓ .github/workflows/sync-web-gallery.yml

✅ YAML validation passed
[main abc1234] Update workflow
 1 file changed, 5 insertions(+)
```

### Bypass Hook (Not Recommended)

If you need to bypass validation (not recommended):
```bash
git commit --no-verify
```

---

---

## Automated YAML Validation

In addition to local validation, this repository includes a GitHub Actions workflow that automatically validates YAML files on every pull request.

**Workflow:** `.github/workflows/validate-yaml.yml`

**Triggers:**
- Pull requests that modify `.github/workflows/*.yml` files
- Pushes to main that modify workflow files
- Manual dispatch

**What it does:**
1. Installs Python with PyYAML
2. Installs actionlint for comprehensive GitHub Actions validation
3. Runs `validate-yaml.sh` to check all workflow files
4. Comments on PR if validation fails

**Benefits:**
- ✅ Automatic validation on every PR
- ✅ Quick feedback before merging
- ✅ Prevents broken workflows from reaching main
- ✅ No manual validation needed for contributors

---

## Directory Structure

```
scripts/
├── generate-exports.sh      # Generate STL/PNG from SCAD
├── validate-yaml.sh         # Validate workflow YAML files
├── install-hooks.sh         # Install Git pre-commit hooks
├── hooks/
│   └── pre-commit          # Pre-commit hook template
└── README.md               # This file
```

## Workflows

```
.github/workflows/
├── generate-stl-png.yml     # Auto-generate STL/PNG from SCAD
├── sync-web-gallery.yml     # Auto-sync web gallery
└── validate-yaml.yml        # Validate workflow YAML files
```
