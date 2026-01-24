# CLAUDE.md - AI Assistant Guide for print-files Repository

## Repository Overview

This is a **3D printing project repository** containing parametric designs and pre-generated 3D model files for custom accessories and mounts. The repository serves as a portfolio of reusable 3D printable designs with a mix of parametric source files (OpenSCAD) and production-ready models (STL).

**Repository Type:** Personal/hobby 3D printing project collection
**Primary Languages:** OpenSCAD (parametric modeling), Binary STL (3D models)
**Version Control:** Git
**Last Updated:** January 2026

---

## Repository Structure

```
print-files/
├── README.md                      # Minimal project documentation (14 bytes)
├── eB fan Shroud/                 # Complete fan shroud design with LED fixture
│   ├── eB fan shroud with 5mm straw hat fixture.stl  (953 KB)
│   ├── eB fan shroud with 5mm straw hat fixture.png  (53 KB preview)
│   └── .public                    # Marker indicating shareable design
├── led-grill/                     # LED grill cover design
│   └── cover.stl                  (21 KB)
└── spigen-pd2101-mount/           # Vertical charger mount (active development)
    └── spigen-pd2101-mount.scad   (2.7 KB parametric source)
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

### 4. Marker Files (`.public`)

**Purpose:** Indicates publicly shareable designs
**Usage:** Empty file serving as metadata flag

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
6. **Add `.public` marker** if design is shareable
7. **Commit with descriptive message**

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
- `.public` marker with initial design

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

### Task 3: Export and Add STL

```bash
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

---

## Design Philosophy and Constraints

### Design Goals

1. **Functional:** Designs solve specific real-world problems
2. **Printable:** Optimized for FDM 3D printing
3. **Parametric:** Easily adjustable for different use cases
4. **Well-documented:** Clear comments explain design decisions
5. **Shareable:** Include public marker for community designs

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
- **Clean up obsolete designs** or move to archive
- **Update preview images** for modified designs
- **Document successful print settings** in comments
- **Tag stable releases** for major design milestones

### Future Improvements

Consider adding:
- Detailed README.md with project gallery
- Print settings documentation per project
- Assembly instructions for complex designs
- BOM (Bill of Materials) for hardware requirements
- License information (Creative Commons, GPL, etc.)

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
