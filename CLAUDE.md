# CLAUDE.md - AI Assistant Guide for print-files Repository

## Repository Overview

This is a **3D printing project repository** containing parametric designs and pre-generated 3D model files for custom accessories and mounts. The repository serves as a collection of reusable 3D printable designs with a mix of parametric source files (OpenSCAD) and production-ready models (STL).

The repository includes an **interactive web gallery** hosted on GitHub Pages for showcasing designs with 3D model viewing, source code browsing, and direct downloads.

**Repository Type:** Personal/hobby 3D printing project collection
**Primary Languages:** OpenSCAD (parametric modeling), Binary STL (3D models), HTML/CSS/JavaScript (web gallery)
**Version Control:** Git
**Web Gallery:** https://stevendejongnl.github.io/print-files/
**Last Updated:** January 2026

---

## Repository Structure

```
print-files/
├── README.md                      # Project documentation
├── CLAUDE.md                      # AI assistant guide (this file)
├── docs/                          # Web gallery (GitHub Pages)
│   ├── index.html                 # Interactive 3D model viewer
│   ├── projects.json              # Auto-generated project metadata
│   ├── README.md                  # Web gallery documentation
│   ├── .nojekyll                  # Disables Jekyll processing
│   └── projects/                  # Synced copies of project files
│       ├── eB fan Shroud/
│       ├── led-grill/
│       └── spigen-pd2101-mount/
├── .github/
│   └── workflows/
│       ├── generate-stl-png.yml   # Automated STL/PNG generation
│       └── sync-web-gallery.yml   # Auto-sync web gallery
├── scripts/
│   ├── generate-exports.sh        # Local automation script
│   └── README.md                  # Scripts documentation
├── eB fan Shroud/                 # Complete fan shroud design with LED fixture
│   ├── eB fan shroud with 5mm straw hat fixture.stl  (953 KB)
│   └── eB fan shroud with 5mm straw hat fixture.png  (53 KB preview)
├── led-grill/                     # LED grill cover design
│   └── cover.stl                  (21 KB)
└── spigen-pd2101-mount/           # Vertical charger mount (active development)
    ├── spigen-pd2101-mount.scad   (2.7 KB parametric source)
    ├── spigen-pd2101-mount.stl    (auto-generated)
    └── spigen-pd2101-mount.png    (auto-generated)
```

### Directory Organization

- **Each project has its own dedicated directory**
- **Mixed maturity levels:**
  - `eB fan Shroud/` - Mature, production-ready (STL + preview)
  - `led-grill/` - Stable, minimal component (STL only)
  - `spigen-pd2101-mount/` - Active development (SCAD source)

---

## File Types and Their Purposes

### 1. OpenSCAD Files (`.scad`)

**Purpose:** Parametric 3D model source code
**Language:** OpenSCAD scripting language
**Editability:** Human-readable, version-control friendly
**Example:** `spigen-pd2101-mount.scad`

**When to use:**
- Creating new designs from scratch
- Modifying existing parametric designs
- Maintaining design flexibility
- Documenting design intent and parameters

### 2. STL Files (`.stl`)

**Purpose:** 3D printable mesh models
**Format:** Binary STL (Standard Tessellation Language)
**Editability:** Pre-rendered, ready for slicing
**Examples:** `eB fan shroud with 5mm straw hat fixture.stl`, `cover.stl`

**When to use:**
- Final export for 3D printing
- Sharing with users who need ready-to-print files
- When parametric source is not needed

### 3. Preview Images (`.png`)

**Purpose:** Visual documentation and preview
**Example:** `eB fan shroud with 5mm straw hat fixture.png`

**When to use:**
- Documenting final design appearance
- Creating visual documentation
- README illustrations

---

## Web Gallery

This repository includes an **interactive web-based gallery** hosted on GitHub Pages for showcasing 3D designs.

**Live Gallery:** https://stevendejongnl.github.io/print-files/

### Features

1. **Interactive 3D Viewer**
   - Built with Three.js and STLLoader
   - Rotate, zoom, and pan 3D models in the browser
   - Wireframe toggle mode
   - Camera reset controls
   - OrbitControls for intuitive navigation

2. **Preview Image Viewer**
   - Display PNG renderings of models
   - Full-screen modal view
   - High-quality previews

3. **Source Code Viewer**
   - Browse OpenSCAD source code
   - Syntax highlighting with Prism.js
   - Readable code formatting
   - Direct download links

4. **Project Metadata**
   - Auto-generated from repository contents
   - Public/private badges
   - File type indicators (STL, SCAD, PNG)
   - Category organization

### Technology Stack

- **Frontend:** Pure HTML/CSS/JavaScript (no build step)
- **3D Rendering:** Three.js r128
- **STL Loading:** Three.js STLLoader
- **Camera Controls:** Three.js OrbitControls
- **Syntax Highlighting:** Prism.js
- **Hosting:** GitHub Pages (from `/docs` folder)

### File Structure

```
docs/
├── index.html         # Main gallery interface
├── projects.json      # Auto-generated project metadata
├── README.md          # Gallery documentation
├── .nojekyll          # Disables Jekyll processing for GitHub Pages
└── projects/          # Synced project files (auto-updated)
    └── [project-name]/
        ├── *.stl
        ├── *.png
        └── *.scad
```

### Automatic Synchronization

The web gallery is **automatically synchronized** via GitHub Actions:

**Workflow:** `.github/workflows/sync-web-gallery.yml`

**Triggers:**
- Any push to `.stl`, `.png`, `.scad` files
- Manual workflow dispatch

**Actions:**
1. Syncs all project files to `docs/projects/`
2. Generates `projects.json` with metadata
3. Commits and pushes changes automatically

**This means:**
- ✅ No manual copying of files to `docs/`
- ✅ No manual editing of `projects.json`
- ✅ Gallery stays in sync with repository automatically

### Adding Projects to Gallery

Simply add your 3D files to the repository root:

```bash
# Add new project
mkdir my-new-design/
# Add .scad, .stl, .png files
git add my-new-design/
git commit -m "Add new design"
git push

# Wait 2-3 minutes for automation
# Gallery automatically updates!
```

### Customizing the Gallery

**To modify gallery appearance:**
Edit `docs/index.html` - CSS variables are defined in `:root`:

```css
:root {
    --primary-color: #3498db;
    --secondary-color: #2c3e50;
    --accent-color: #e74c3c;
    /* ... etc */
}
```

**To customize project metadata:**
Projects are auto-generated, but you can manually edit `docs/projects.json`:

```json
{
  "name": "Project Name",
  "description": "Project description",
  "stl": "projects/folder/file.stl",
  "preview": "projects/folder/file.png",
  "scad": "projects/folder/file.scad",
  "isPublic": true,
  "category": "Category Name"
}
```

Note: Manual edits to `projects.json` will be overwritten by the sync workflow.

### Local Testing

To test the gallery locally before deploying:

```bash
cd docs
python3 -m http.server 8000
# Open http://localhost:8000
```

Or use Node.js:

```bash
npx http-server docs -p 8000
```

### GitHub Pages Setup

The gallery is configured for GitHub Pages deployment:

1. **Repository Settings → Pages**
2. **Source:** Deploy from a branch
3. **Branch:** `main`
4. **Folder:** `/docs`
5. **Save**

The site will be available at: `https://[username].github.io/[repository-name]/`

**Note:** GitHub Pages requires a **public repository** on free tier.

---

## Development Workflows

### Workflow 1: Creating a New Design

1. **Create a new directory** with a descriptive name (e.g., `product-name-mount/`)
2. **Start with OpenSCAD** for parametric flexibility:
   - Create `[descriptive-name].scad` file
   - Use clear section headers with `// ===` dividers
   - Define parameters at the top of the file
   - Add inline documentation
3. **Test in OpenSCAD** preview (F5) and render (F6)
4. **Export STL** when design is finalized (File → Export → Export as STL)
5. **Add preview image** (optional but recommended):
   - Take screenshot from OpenSCAD
   - Or photograph/render final print
6. **Commit with descriptive message**

### Workflow 2: Modifying Existing Parametric Design

1. **Read the `.scad` file** to understand parameters
2. **Modify parameters** or geometry as needed
3. **Preview changes** in OpenSCAD (F5 for quick preview)
4. **Render to verify** (F6 for full render)
5. **Export new STL** if needed
6. **Update preview image** if visual changes are significant
7. **Commit changes** with clear description

### Workflow 3: Exporting Ready-to-Print Models

1. **Open the `.scad` file** in OpenSCAD
2. **Verify all parameters** are set correctly
3. **Render** (F6) - wait for completion
4. **Export as STL:**
   - File → Export → Export as STL
   - Use binary STL format (default)
   - Name: `[descriptive-name].stl`
5. **Validate STL:**
   - Check file size (should be reasonable)
   - Open in slicer software to verify manifold geometry
6. **Commit both source and export** together

### Workflow 4: Automated Export (Recommended)

**Use the automated tools instead of manual export!**

This repository includes automation to generate STL and PNG files from SCAD sources:

#### Option A: Local Script (Immediate)
```bash
# Generate exports for all .scad files
./scripts/generate-exports.sh

# Generate exports for specific file
./scripts/generate-exports.sh spigen-pd2101-mount/spigen-pd2101-mount.scad
```

**Requirements:** OpenSCAD must be installed locally
**Output:** Creates `.stl` and `.png` files next to each `.scad` file

#### Option B: GitHub Actions (Automatic)
Simply push your `.scad` file changes to GitHub:
```bash
git add myproject/mydesign.scad
git commit -m "Update design parameters"
git push
```

The GitHub Actions workflow will automatically:
1. Detect the changed `.scad` file
2. Generate STL and PNG files
3. Commit and push them back to the repository

**Manual trigger:** Go to Actions tab → "Generate STL and PNG from SCAD files" → "Run workflow"

**Benefits:**
- No need to manually export before committing
- Ensures consistency (same OpenSCAD version for all exports)
- Works even if you don't have OpenSCAD installed locally
- Automatic PNG previews with optimal camera angles

---

## OpenSCAD Code Conventions

### File Structure (Based on `spigen-pd2101-mount.scad`)

```openscad
// ============================================================
// SECTION HEADER
// ============================================================

// Parameter definitions
param1 = value;
param2 = value;

// ---------- Subsection ----------
calculated_value = param1 + param2;

// ============================================================
// MODULES
// ============================================================

module component_name() {
    // Module implementation
}

// ============================================================
// MODEL
// ============================================================

difference() {
    // OUTER BODY
    component_name();

    // INNER CAVITY
    // ... (with comments for each operation)
}
```

### Documentation Standards

1. **Section Headers:**
   ```openscad
   // ============================================================
   // CLEAR SECTION NAME
   // ============================================================
   ```

2. **Subsection Dividers:**
   ```openscad
   // ---------- Subsection Name ----------
   ```

3. **Inline Comments:**
   - Explain design intent, not obvious code
   - Document physical dimensions and tolerances
   - Note manufacturing constraints

4. **Parameter Documentation:**
   ```openscad
   // Charger dimensions
   charger_w = 40.4;      // Width in mm
   charger_h = 75;        // Height in mm
   tolerance = 0.6;       // Fit tolerance
   ```

### Naming Conventions

- **Variables:** Use lowercase with underscores: `wall_thickness`, `screw_diameter`
- **Modules:** Use lowercase with underscores: `chamfer_rect()`, `mounting_plate()`
- **Constants:** Use descriptive names: `tolerance`, `lip_height`
- **Dimensions:** Include unit context: `_w` (width), `_h` (height), `_d` (diameter)

### Best Practices

1. **Parametric First:** Always define dimensions as parameters at the top
2. **Tolerance Values:** Explicitly document fit tolerances
3. **Manufacturing Notes:** Comment on print orientation, support requirements
4. **Modular Design:** Create reusable modules for common shapes
5. **Derived Calculations:** Calculate dependent values programmatically
6. **Boolean Operations:** Use clear comments for difference/union operations

---

## File Naming Conventions

### General Pattern

```
[Product/Component] [Variant/Description].[extension]
```

### Examples

- ✅ `eB fan shroud with 5mm straw hat fixture.stl`
- ✅ `spigen-pd2101-mount.scad`
- ✅ `cover.stl`
- ❌ `model1.stl` (not descriptive)
- ❌ `temp_file.scad` (not meaningful)

### Guidelines

- **Be descriptive:** Name should indicate what the object is
- **Include variant info:** Specify important features or dimensions
- **Use spaces:** Readable names are preferred over hyphens
- **No version numbers:** Use Git for versioning, not filenames
- **Match directory name:** SCAD filename should reflect project name

---

## Git Workflow and Conventions

### Branch Strategy

- **Main branch:** Stable, tested designs
- **Feature branches:** Use format `claude/[description]-[sessionID]`
- **Development:** Work on designated feature branches
- **Never push directly to main** without review

### Commit Message Guidelines

Based on repository history:

```
Update [component-name].scad          # For modifications
Add [new-component-name]              # For new designs
Create [new-file]                     # For new files
Update stl, screenshot and public     # For batch updates
```

**Best Practices:**
- Use imperative mood ("Add" not "Added")
- Be specific about what changed
- Reference component/file names
- Group related changes in single commit

### What to Commit

**Always commit together:**
- `.scad` source file + exported `.stl` (if both exist)
- Updated preview `.png` when design changes

**Commit frequency:**
- After each significant design iteration
- When parameters are tuned and tested
- Before and after major geometry changes

---

## Testing and Validation

### For OpenSCAD Files

1. **Syntax Check:**
   - Open in OpenSCAD
   - Check for errors in console
   - Verify no warnings

2. **Preview Test (F5):**
   - Fast preview renders correctly
   - No missing geometry
   - Boolean operations complete

3. **Full Render (F6):**
   - Complete render without errors
   - Manifold geometry (no holes)
   - Reasonable polygon count

4. **Dimensional Accuracy:**
   - Measure critical dimensions in preview
   - Verify tolerance calculations
   - Check clearances

### For STL Files

1. **Manifold Check:**
   - Import into slicer (Cura, PrusaSlicer, etc.)
   - Verify "manifold" or "watertight" status
   - No errors reported

2. **File Size Sanity:**
   - Binary STL should be reasonable size
   - Compare with similar complexity models
   - If too large (>50MB), consider reducing $fn/$fa/$fs

3. **Visual Inspection:**
   - Check for missing faces
   - Verify surface normals (correct orientation)
   - Look for artifacts or mesh errors

### Physical Print Testing

When possible, document:
- Print settings used (layer height, infill, material)
- Fit and tolerance results
- Any design adjustments needed
- Assembly notes

---

## Common Tasks for AI Assistants

### Task 1: Create a New Parametric Design

```bash
# 1. Create project directory
mkdir "new-component-mount"

# 2. Create SCAD file (use Write tool)
# Include: section headers, parameters, modules, model

# 3. Test in OpenSCAD (manual step - instruct user)

# 4. Add to git
git add "new-component-mount/"
git commit -m "Add new-component-mount design"
```

### Task 2: Modify Existing Design Parameters

```bash
# 1. Read the .scad file
# 2. Use Edit tool to modify parameters
# 3. Instruct user to preview/render
# 4. Commit changes
git add [file].scad
git commit -m "Update [component] dimensions for better fit"
```

### Task 3: Generate STL and PNG (Automated - Recommended)

```bash
# Option A: Use local automation script (if user has OpenSCAD)
./scripts/generate-exports.sh path/to/file.scad

# Review generated files
ls -lh path/to/

# Commit all files together
git add path/to/
git commit -m "Add [component] with generated exports"
git push

# Option B: Let GitHub Actions do it (if user doesn't have OpenSCAD)
# Just commit the .scad file
git add path/to/file.scad
git commit -m "Add [component] design"
git push

# Inform user: "GitHub Actions will automatically:
# 1. Generate STL and PNG files
# 2. Sync files to web gallery (docs/projects/)
# 3. Update projects.json
# Wait 3-5 minutes, then run 'git pull' to get the updates.
# Check the web gallery at: https://[username].github.io/[repo-name]/"
```

### Task 3b: Manual Export (Legacy - Not Recommended)

```bash
# Only use if automation is unavailable
# 1. Instruct user to:
#    - Open .scad in OpenSCAD
#    - Render (F6)
#    - Export as STL
# 2. Once user confirms, add to git
git add [file].stl
git commit -m "Add exported STL for [component]"
```

### Task 4: Update Documentation

```bash
# 1. Update README.md with project descriptions
# 2. Add preview images
# 3. Document print settings if known
git add README.md [preview-images]
git commit -m "Update documentation with [details]"
```

### Task 5: Verify Web Gallery

```bash
# After pushing changes, verify the web gallery is updated:
# 1. Wait 3-5 minutes for GitHub Actions to complete
# 2. Check Actions tab for workflow status
# 3. Pull latest changes: git pull
# 4. Verify files in docs/projects/[project-name]/
# 5. Check live gallery: https://[username].github.io/[repo-name]/

# If gallery is not updating:
# - Check GitHub Pages is enabled (Settings → Pages)
# - Source should be: main branch, /docs folder
# - Check workflow logs in Actions tab
# - Manually trigger "Sync Web Gallery" workflow if needed
```

---

## Design Philosophy and Constraints

### Design Goals

1. **Functional:** Designs solve specific real-world problems
2. **Printable:** Optimized for FDM 3D printing
3. **Parametric:** Easily adjustable for different use cases
4. **Well-documented:** Clear comments explain design decisions

### Manufacturing Constraints

**Consider when designing:**
- **Print orientation:** Minimize supports, optimize layer lines
- **Tolerances:** Account for printer accuracy (0.2-0.6mm typical)
- **Wall thickness:** Minimum 2-4mm for structural parts
- **Overhangs:** Limit to 45° without supports when possible
- **Bridging:** Keep spans reasonable (<20mm without support)
- **Screw holes:** Add extra clearance (0.4-0.6mm for M3 screws)

### Material Assumptions

Most designs assume:
- **Material:** PLA or PETG
- **Layer height:** 0.2mm
- **Nozzle size:** 0.4mm
- **Infill:** 20-50% depending on strength needs

---

## Tools and Dependencies

### Required Software

1. **OpenSCAD** (latest version)
   - Download: https://openscad.org/downloads.html
   - Used for: Creating and modifying parametric designs
   - Keyboard shortcuts: F5 (preview), F6 (render)

2. **3D Slicer Software** (one of):
   - Cura, PrusaSlicer, Simplify3D
   - Used for: STL validation and printing

3. **Git** (for version control)
   - Required for all development workflows

### Optional Tools

- **MeshLab/Blender:** Advanced STL editing/repair
- **Image editor:** Creating/editing preview images
- **Calipers:** Measuring physical dimensions

---

## Automation Infrastructure

This repository includes automated tools to generate STL and PNG files from OpenSCAD sources, eliminating manual export steps and ensuring consistency.

### Local Automation Script

**Location:** `scripts/generate-exports.sh`

**What it does:**
- Finds all `.scad` files in the repository
- Generates binary STL files (ready for 3D printing)
- Creates PNG preview images (1024x768, orthographic view)
- Processes files in parallel for efficiency

**Usage:**
```bash
# Process all .scad files
./scripts/generate-exports.sh

# Process specific file(s)
./scripts/generate-exports.sh path/to/file.scad
```

**Requirements:**
- OpenSCAD installed locally
- macOS: `brew install openscad`
- Ubuntu: `sudo apt-get install openscad`
- Windows: Download from openscad.org

**Output format:**
- STL: Binary format, production-ready
- PNG: 1024x768px, ortho projection, Tomorrow color scheme
- Both files created in same directory as source `.scad`

### GitHub Actions Workflow

**Location:** `.github/workflows/generate-stl-png.yml`

**Triggers:**
- Automatically when `.scad` files are pushed
- Manually via Actions tab → "Run workflow"

**What it does:**
1. Detects all `.scad` files in repository
2. Installs OpenSCAD in CI environment
3. Generates STL and PNG for each file
4. Commits generated files back to repository
5. Skips CI on auto-commits (prevents loops)

**Benefits:**
- **No local OpenSCAD needed:** Contributors can edit `.scad` files without installing OpenSCAD
- **Consistency:** Same OpenSCAD version used for all exports
- **Automatic previews:** PNG images always up-to-date
- **Time-saving:** No manual export workflow needed
- **Version control:** Generated files tracked in git history

**Workflow details:**
```yaml
Trigger: Push to *.scad files
Job: generate-files
  1. Checkout repository
  2. Find all .scad files
  3. Install OpenSCAD + xvfb (headless rendering)
  4. Generate STL and PNG for each file
  5. Commit changes (if any)
  6. Push back to same branch
```

**Manual trigger:**
1. Navigate to repository on GitHub
2. Click "Actions" tab
3. Select "Generate STL and PNG from SCAD files"
4. Click "Run workflow"
5. Choose branch and confirm

**Customizing PNG output:**

Edit `.github/workflows/generate-stl-png.yml` to change preview settings:

```yaml
--imgsize=1024,768          # Image dimensions
--projection=ortho          # ortho or perspective
--colorscheme=Tomorrow      # Color scheme
--camera=0,0,0,60,0,25,500  # Camera position and angle
```

### Web Gallery Sync Workflow

**Location:** `.github/workflows/sync-web-gallery.yml`

**Triggers:**
- Any push to `.stl`, `.png`, `.scad` files
- Manually via Actions tab → "Run workflow"

**What it does:**
1. Syncs all project files from repository root to `docs/projects/`
2. Auto-generates `projects.json` metadata from repository contents
3. Commits and pushes changes to the gallery
4. Updates web gallery automatically

**Benefits:**
- **No manual copying:** Project files automatically synced to docs/
- **No manual JSON editing:** Metadata generated from file system
- **Always up-to-date:** Gallery reflects current repository state
- **Automatic discovery:** New projects appear automatically

**Workflow details:**
```yaml
Trigger: Push to *.stl, *.png, *.scad files
Job: sync-gallery
  1. Checkout repository
  2. Remove old docs/projects/ directory
  3. Find all project directories in repository
  4. Copy project files to docs/projects/
  5. Generate projects.json from discovered files
  6. Commit changes (if any)
  7. Push back to same branch
```

**Generated metadata:**
The workflow automatically creates `projects.json` entries:
- Discovers project name from directory
- Finds STL, PNG, and SCAD files
- Sets all projects as public (isPublic: true)
- Creates relative paths for web access

**Manual trigger:**
1. Navigate to repository on GitHub
2. Click "Actions" tab
3. Select "Sync Web Gallery"
4. Click "Run workflow"
5. Choose branch and confirm

**Important notes:**
- Manual edits to `docs/projects.json` will be overwritten
- Files are synced from repository root to `docs/projects/`
- Both workflows work together: STL generation → Gallery sync
- Workflow includes `[skip ci]` to prevent infinite loops

### Best Practices with Automation

**Do:**
- ✅ Commit `.scad` source files first
- ✅ Let automation generate STL/PNG (don't commit manual exports)
- ✅ Let automation sync files to docs/ (don't manually copy)
- ✅ Review auto-generated files after workflow completes
- ✅ Pull latest changes after GitHub Actions runs
- ✅ Use local script for quick iteration during development

**Don't:**
- ❌ Manually export and commit STL/PNG alongside `.scad` changes
- ❌ Manually copy files to `docs/projects/` directory
- ❌ Manually edit `docs/projects.json` (will be overwritten)
- ❌ Edit generated files directly (changes will be overwritten)
- ❌ Commit large STL files if `.scad` source is available
- ❌ Ignore workflow failures (check Actions tab for errors)

### Workflow Integration

**Typical development flow:**

```bash
# 1. Make changes to SCAD file
vim myproject/design.scad

# 2. Test locally (optional but recommended)
./scripts/generate-exports.sh myproject/design.scad

# 3. Review generated STL/PNG
# Open in slicer or image viewer

# 4. Commit and push SCAD source
git add myproject/design.scad
git commit -m "Adjust wall thickness for better strength"
git push

# 5. GitHub Actions automatically:
#    - Generates STL/PNG from SCAD (workflow 1)
#    - Syncs files to docs/projects/ (workflow 2)
#    - Updates projects.json (workflow 2)
# Wait ~3-5 minutes for both workflows to complete

# 6. Pull generated files and gallery updates
git pull

# 7. Verify auto-generated exports and web gallery
ls -lh myproject/
# Check: https://[username].github.io/[repo-name]/
```

**For urgent local testing:**
```bash
# Generate and test immediately without waiting for CI
./scripts/generate-exports.sh myproject/design.scad
# Test the STL in your slicer
# When satisfied, commit everything together
git add myproject/
git commit -m "Update design with tested exports"
git push
```

---

## Troubleshooting Common Issues

### OpenSCAD Render Errors

**Problem:** "Object isn't a valid 2-manifold"
- **Solution:** Check difference() operations, ensure all shapes are closed

**Problem:** Extremely slow render
- **Solution:** Reduce $fn value, simplify geometry, use $fa/$fs instead

**Problem:** Missing geometry in preview
- **Solution:** Check for invalid boolean operations, verify module calls

### STL Export Issues

**Problem:** STL file is huge (>100MB)
- **Solution:** Reduce circle resolution ($fn), simplify curves

**Problem:** Slicer reports errors
- **Solution:** Re-render in OpenSCAD, check manifold status, use repair tools

### Git/Commit Issues

**Problem:** Large binary files slow down repository
- **Solution:** Use Git LFS for large STLs if repository grows significantly

---

## Quick Reference

### OpenSCAD Syntax Quick Ref

```openscad
// Basic shapes
cube([x, y, z]);
cylinder(h=height, r=radius, $fn=segments);
sphere(r=radius, $fn=segments);

// Boolean operations
difference() { shape1; shape2; }  // Subtract shape2 from shape1
union() { shape1; shape2; }       // Combine shapes
intersection() { shape1; shape2; } // Keep only overlap

// Transformations
translate([x, y, z]) shape;
rotate([x, y, z]) shape;
scale([x, y, z]) shape;

// Modules
module my_module(param1, param2) {
    // Module code
}
```

### Common OpenSCAD Variables

```openscad
$fn = 100;           // Circle resolution (higher = smoother)
$fa = 12;            // Minimum angle
$fs = 2;             // Minimum size
```

### File Operations Checklist

- [ ] Read existing files before modifying
- [ ] Test SCAD changes in OpenSCAD preview
- [ ] Validate STL in slicer before committing
- [ ] Update preview images if design changes visually
- [ ] Write clear commit messages
- [ ] Commit source and exports together

---

## Additional Notes for AI Assistants

### When Reading This Repository

1. **Always check for `.scad` source** before modifying STL files
2. **Read parameters first** to understand design constraints
3. **Look for tolerance values** - these are critical for fit
4. **Check git history** to understand design evolution
5. **Respect existing code style** and documentation patterns

### When Modifying Designs

1. **Never guess dimensions** - read from source or ask user
2. **Preserve parametric flexibility** - don't hardcode values
3. **Document your changes** in comments
4. **Consider print implications** of geometry changes
5. **Test before committing** (instruct user to preview)

### When Creating New Designs

1. **Start with clear requirements** - dimensions, fit, purpose
2. **Define all parameters at top** of file
3. **Use modular design** - create reusable components
4. **Add comprehensive comments** - explain "why" not just "what"
5. **Plan for tolerances** from the beginning
6. **Consider print orientation** and support needs

### Communication Best Practices

- **Explain design tradeoffs** when making decisions
- **Request measurements** when dimensions are unclear
- **Suggest print settings** when known
- **Warn about tolerances** that might need adjustment
- **Recommend test prints** for critical fits

---

## Repository Maintenance

### Periodic Tasks

- **Review and update README.md** with project descriptions
- **Verify web gallery** is displaying projects correctly
- **Clean up obsolete designs** or move to archive
- **Update preview images** for modified designs
- **Document successful print settings** in comments
- **Tag stable releases** for major design milestones
- **Monitor GitHub Actions workflows** for failures
- **Check GitHub Pages deployment** status

### Implemented Features

✅ **Completed:**
- Interactive web gallery with 3D viewer
- Automatic STL/PNG generation from SCAD
- Automatic web gallery synchronization
- Detailed README.md and CLAUDE.md documentation

### Future Improvements

Consider adding:
- Print settings documentation per project
- Assembly instructions for complex designs
- BOM (Bill of Materials) for hardware requirements
- License information per project (Creative Commons, GPL, etc.)
- Project categories and filtering in web gallery
- Search functionality in web gallery
- User comments or feedback system

---

## Contact and Contribution

This repository appears to be a personal project collection. When working on this repository:

- Follow established conventions
- Maintain code quality and documentation standards
- Test changes before committing
- Write clear, descriptive commit messages
- Ask for clarification when requirements are unclear

---

**Document Version:** 1.0
**Last Updated:** January 24, 2026
**Maintained for:** AI assistants working with this 3D printing repository
