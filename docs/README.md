# 3D Print Files - Web Gallery

This directory contains the web-based portfolio viewer for showcasing 3D printable designs.

## Features

- **Interactive 3D Viewer**: View STL files directly in your browser using Three.js
- **Preview Images**: See PNG renderings of models
- **Source Code Viewer**: Browse OpenSCAD source code with syntax highlighting
- **Responsive Design**: Works on desktop, tablet, and mobile devices
- **Direct Downloads**: Download STL, SCAD, and preview files

## Technology Stack

- **Three.js**: 3D model rendering and STL loading
- **OrbitControls**: Interactive camera controls for 3D viewing
- **Prism.js**: Syntax highlighting for OpenSCAD code
- **Pure HTML/CSS/JS**: No build step required

## File Structure

```
docs/
├── index.html         # Main gallery page
├── projects.json      # Project metadata
├── .nojekyll          # Disables Jekyll processing
└── README.md          # This file
```

## Adding New Projects

To add a new project to the gallery:

1. Add your project files to the repository root (STL, SCAD, PNG)
2. Update `projects.json` with your project metadata:

```json
{
  "name": "Project Name",
  "description": "Brief description",
  "stl": "path/to/file.stl",
  "preview": "path/to/preview.png",
  "scad": "path/to/source.scad",
  "isPublic": true,
  "category": "Category Name"
}
```

3. Commit and push changes
4. The gallery will automatically update on GitHub Pages

## Local Development

To test the website locally:

```bash
# Simple HTTP server (Python 3)
cd docs
python3 -m http.server 8000

# Or using Node.js
npx http-server docs -p 8000
```

Then open http://localhost:8000 in your browser.

## GitHub Pages Configuration

This site is configured to be served from the `/docs` folder on GitHub Pages.

To enable:
1. Go to repository Settings → Pages
2. Source: Deploy from a branch
3. Branch: Select your branch and `/docs` folder
4. Save

The site will be available at: `https://[username].github.io/[repository-name]/`

## Browser Compatibility

- **Chrome/Edge**: Full support
- **Firefox**: Full support
- **Safari**: Full support (iOS 15+)
- **Mobile**: Responsive design works on all modern mobile browsers

## Credits

- Three.js for 3D rendering
- Prism.js for code highlighting
- OpenSCAD for parametric design
