#!/bin/bash

# ============================================================
# Generate STL and PNG files from OpenSCAD sources
# ============================================================
# This script finds all .scad files and generates:
# - Binary STL files for 3D printing
# - PNG preview images
#
# Requirements: OpenSCAD must be installed
# Usage: ./scripts/generate-exports.sh [file.scad]
#        (if no file specified, processes all .scad files)
# ============================================================

set -e  # Exit on error

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Check if OpenSCAD is installed
if ! command -v openscad &> /dev/null; then
    echo -e "${RED}Error: OpenSCAD is not installed${NC}"
    echo "Please install OpenSCAD:"
    echo "  - macOS: brew install openscad"
    echo "  - Ubuntu/Debian: sudo apt-get install openscad"
    echo "  - Windows: Download from https://openscad.org/downloads.html"
    exit 1
fi

echo -e "${BLUE}OpenSCAD version:${NC}"
openscad --version
echo ""

# Function to process a single SCAD file
process_scad_file() {
    local scad_file="$1"

    if [ ! -f "$scad_file" ]; then
        echo -e "${RED}Error: File not found: $scad_file${NC}"
        return 1
    fi

    echo -e "${BLUE}Processing: ${scad_file}${NC}"

    # Get directory and base filename
    local dir=$(dirname "$scad_file")
    local base=$(basename "$scad_file" .scad)

    # Output files
    local stl_file="$dir/$base.stl"
    local png_file="$dir/$base.png"

    # Generate STL file
    echo -e "  ${YELLOW}Generating STL: $stl_file${NC}"
    if openscad -o "$stl_file" "$scad_file" 2>&1 | grep -v "^$"; then
        if [ -f "$stl_file" ]; then
            echo -e "  ${GREEN}✓ STL generated successfully${NC}"
            ls -lh "$stl_file"
        else
            echo -e "  ${RED}✗ Failed to generate STL${NC}"
            return 1
        fi
    fi

    # Generate PNG preview
    echo -e "  ${YELLOW}Generating PNG: $png_file${NC}"
    if openscad -o "$png_file" \
        --imgsize=1024,768 \
        --view=axes,scales \
        --projection=ortho \
        --colorscheme=Tomorrow \
        --camera=0,0,0,60,0,25,500 \
        "$scad_file" 2>&1 | grep -v "^$"; then
        if [ -f "$png_file" ]; then
            echo -e "  ${GREEN}✓ PNG generated successfully${NC}"
            ls -lh "$png_file"
        else
            echo -e "  ${RED}✗ Failed to generate PNG${NC}"
            return 1
        fi
    fi

    echo ""
}

# Main execution
main() {
    if [ $# -eq 0 ]; then
        # No arguments - process all .scad files
        echo -e "${BLUE}Finding all .scad files...${NC}"
        scad_files=$(find . -name "*.scad" -not -path "./.git/*" | sort)

        if [ -z "$scad_files" ]; then
            echo -e "${YELLOW}No .scad files found${NC}"
            exit 0
        fi

        echo -e "${GREEN}Found $(echo "$scad_files" | wc -l) .scad file(s)${NC}"
        echo ""

        # Process each file
        while IFS= read -r scad_file; do
            process_scad_file "$scad_file"
        done <<< "$scad_files"

    else
        # Process specified file(s)
        for scad_file in "$@"; do
            process_scad_file "$scad_file"
        done
    fi

    echo -e "${GREEN}✓ All files processed${NC}"
}

# Run main function
main "$@"
