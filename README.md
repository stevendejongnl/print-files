# 3D Print Files

A collection of 3D printable designs and parametric models created with OpenSCAD.

## 🌐 Web Gallery

Browse all projects in an interactive web gallery:

**[View Gallery](https://stevendejongnl.github.io/print-files/)**

Features:
- **Interactive 3D Viewer** - Rotate and inspect STL models in your browser
- **Source Code Viewer** - Browse OpenSCAD parametric designs with syntax highlighting
- **Preview Images** - See PNG renderings of models
- **Direct Downloads** - Download STL files ready for 3D printing

## 📦 Projects

### eB Fan Shroud with LED Fixture
Complete fan shroud design with integrated 5mm straw hat LED fixture for cooling and lighting.

### LED Grill Cover
LED grill cover component design.

### Spigen PD2101 Vertical Charger Mount
Parametric mount for Spigen PD2101 vertical wireless charger with adjustable dimensions.

## 🛠️ Repository Structure

```
print-files/
├── docs/                    # Web gallery (GitHub Pages)
│   ├── index.html          # Interactive gallery interface
│   ├── projects.json       # Auto-generated project metadata
│   └── projects/           # Synced project files
├── [project-name]/         # Individual project directories
│   ├── *.scad             # OpenSCAD parametric source
│   ├── *.stl              # 3D printable models
│   ├── *.png              # Preview renders
│   └── .public            # Optional: marks shareable designs
└── .github/workflows/      # Automation
    ├── generate-stl-png.yml    # Auto-generate STL/PNG from SCAD
    └── sync-web-gallery.yml    # Auto-sync web gallery
```

## ✨ Automated Workflows

This repository includes GitHub Actions that automatically:

### 1. Generate STL and PNG Files
When you push `.scad` files, the workflow automatically:
- Generates binary STL files (ready for 3D printing)
- Creates PNG preview images (1024x768, orthographic view)
- Commits the generated files back to your branch

### 2. Sync Web Gallery
When you push any 3D files, the workflow automatically:
- Syncs project files to `docs/projects/`
- Generates `projects.json` metadata
- Updates the web gallery

**No manual export or copying needed!**

## 🚀 Usage

### Adding a New Design

1. **Create a project directory:**
   ```bash
   mkdir my-new-design
   ```

2. **Create your OpenSCAD file:**
   ```bash
   cd my-new-design
   # Create my-new-design.scad
   ```

3. **Commit and push:**
   ```bash
   git add my-new-design/
   git commit -m "Add new design"
   git push
   ```

4. **Wait for automation:**
   - GitHub Actions generates STL and PNG files (~2-3 minutes)
   - Web gallery updates automatically
   - Pull the changes: `git pull`

### Manual Export (Optional)

If you have OpenSCAD installed locally:

```bash
# Generate STL and PNG for all .scad files
./scripts/generate-exports.sh

# Generate for specific file
./scripts/generate-exports.sh path/to/file.scad
```

## 📄 File Types

- **`.scad`** - OpenSCAD parametric source code (human-readable, version-control friendly)
- **`.stl`** - 3D printable mesh models (binary format, ready for slicing)
- **`.png`** - Preview images for documentation
- **`.public`** - Empty marker file indicating publicly shareable designs

## 🔧 Development

### Requirements

- **OpenSCAD** (optional, for local development)
  - macOS: `brew install openscad`
  - Ubuntu: `sudo apt-get install openscad`
  - Windows: Download from [openscad.org](https://openscad.org/)

### Testing the Web Gallery Locally

```bash
cd docs
python3 -m http.server 8000
# Open http://localhost:8000
```

## 📚 Documentation

See [CLAUDE.md](CLAUDE.md) for detailed documentation on:
- Development workflows
- OpenSCAD conventions
- File organization
- Best practices for parametric design
- Automation infrastructure

## 🔗 Links

- **Web Gallery:** https://stevendejongnl.github.io/print-files/
- **OpenSCAD:** https://openscad.org/
- **GitHub Actions:** [.github/workflows/](.github/workflows/)

## 📝 License

See individual project files for licensing information.
