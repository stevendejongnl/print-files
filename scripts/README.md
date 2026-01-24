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
