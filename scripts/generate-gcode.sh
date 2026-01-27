#!/bin/bash

# ============================================================
# Generate G-code files from STL models using CuraEngine
# ============================================================
# This script slices STL files into G-code using CuraEngine
# with filament profiles stored in the profiles/ directory.
#
# Requirements: CuraEngine must be installed
# Usage: ./scripts/generate-gcode.sh [options] [stl_file ...]
#
# Options:
#   --profile <name>      Filament profile (default: pla)
#   --definition <path>   Printer definition JSON file
#   --all                 Process all STL files in repository
#   --help                Show this help message
# ============================================================

set -euo pipefail

# Script location
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
PROFILES_DIR="$REPO_ROOT/profiles"

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Defaults
PROFILE="pla"
PRINTER_DEF=""
PROCESS_ALL=false
STL_FILES=()

# ---------- Helper Functions ----------

usage() {
    echo "Usage: $(basename "$0") [options] [stl_file ...]"
    echo ""
    echo "Generate G-code from STL files using CuraEngine."
    echo ""
    echo "Options:"
    echo "  --profile <name>      Filament profile from profiles/ dir (default: pla)"
    echo "  --definition <path>   Path to printer definition JSON"
    echo "  --all                 Process all STL files in repository"
    echo "  --help                Show this help message"
    echo ""
    echo "Available profiles:"
    if [ -d "$PROFILES_DIR" ]; then
        for cfg in "$PROFILES_DIR"/*.cfg; do
            if [ -f "$cfg" ]; then
                local name
                name=$(basename "$cfg" .cfg)
                local desc
                desc=$(grep -m1 "^#.*Profile" "$cfg" 2>/dev/null | sed 's/^#\s*//' || echo "")
                echo "  $name  ($desc)"
            fi
        done
    else
        echo "  (no profiles directory found)"
    fi
    echo ""
    echo "Examples:"
    echo "  $(basename "$0") model.stl"
    echo "  $(basename "$0") --profile petg project/model.stl"
    echo "  $(basename "$0") --all"
    echo "  $(basename "$0") --all --profile petg"
}

find_curaengine() {
    # Check common CuraEngine binary names and locations
    local candidates=(
        "CuraEngine"
        "curaengine"
        "/usr/bin/CuraEngine"
        "/usr/local/bin/CuraEngine"
        "/usr/bin/curaengine"
        "/snap/cura-slicer/current/usr/bin/CuraEngine"
        "/Applications/UltiMaker Cura.app/Contents/MacOS/CuraEngine"
        "/Applications/Cura.app/Contents/MacOS/CuraEngine"
    )

    for candidate in "${candidates[@]}"; do
        if command -v "$candidate" &>/dev/null; then
            echo "$candidate"
            return 0
        fi
        if [ -x "$candidate" ]; then
            echo "$candidate"
            return 0
        fi
    done

    return 1
}

find_printer_definition() {
    # Look for printer definition in order of priority:
    # 1. User-specified via --definition flag
    # 2. profiles/printer.def.json in repo
    # 3. CURA_DEFINITION environment variable
    # 4. System CuraEngine definitions
    # 5. Download generic fdmprinter definition

    if [ -n "$PRINTER_DEF" ] && [ -f "$PRINTER_DEF" ]; then
        echo "$PRINTER_DEF"
        return 0
    fi

    if [ -f "$PROFILES_DIR/printer.def.json" ]; then
        echo "$PROFILES_DIR/printer.def.json"
        return 0
    fi

    if [ -n "${CURA_DEFINITION:-}" ] && [ -f "${CURA_DEFINITION:-}" ]; then
        echo "$CURA_DEFINITION"
        return 0
    fi

    # Check system locations
    local system_paths=(
        "/usr/share/curaengine/fdmprinter.def.json"
        "/usr/share/cura-engine/fdmprinter.def.json"
        "/usr/share/cura/resources/definitions/fdmprinter.def.json"
        "/snap/cura-slicer/current/usr/share/cura/resources/definitions/fdmprinter.def.json"
    )

    for path in "${system_paths[@]}"; do
        if [ -f "$path" ]; then
            echo "$path"
            return 0
        fi
    done

    # Try to download the generic definition
    local download_path="/tmp/curaengine-fdmprinter.def.json"
    if [ -f "$download_path" ]; then
        echo "$download_path"
        return 0
    fi

    echo -e "${YELLOW}Downloading generic FDM printer definition...${NC}" >&2
    if curl -sL "https://raw.githubusercontent.com/Ultimaker/Cura/main/resources/definitions/fdmprinter.def.json" \
        -o "$download_path" 2>/dev/null; then
        if [ -f "$download_path" ] && [ -s "$download_path" ]; then
            echo "$download_path"
            return 0
        fi
    fi

    return 1
}

build_settings_args() {
    local profile_file="$1"
    local args=()

    while IFS= read -r line; do
        # Skip comments and empty lines
        line=$(echo "$line" | sed 's/#.*//' | xargs)
        if [ -z "$line" ]; then
            continue
        fi

        # Parse key = value
        if [[ "$line" =~ ^([a-zA-Z_][a-zA-Z0-9_]*)\ *=\ *(.+)$ ]]; then
            local key="${BASH_REMATCH[1]}"
            local value="${BASH_REMATCH[2]}"
            value=$(echo "$value" | xargs)  # Trim whitespace
            args+=("-s" "${key}=${value}")
        fi
    done < "$profile_file"

    echo "${args[@]}"
}

# ---------- Process a Single STL File ----------

process_stl_file() {
    local stl_file="$1"
    local curaengine="$2"
    local definition="$3"
    local profile_file="$4"
    local profile_name="$5"

    if [ ! -f "$stl_file" ]; then
        echo -e "${RED}Error: File not found: $stl_file${NC}"
        return 1
    fi

    echo -e "${BLUE}Processing: ${stl_file}${NC}"
    echo -e "  Profile: ${YELLOW}${profile_name}${NC}"

    # Determine output filename: model.stl -> model.<profile>.gcode
    local dir
    dir=$(dirname "$stl_file")
    local base
    base=$(basename "$stl_file" .stl)
    local gcode_file="$dir/$base.$profile_name.gcode"

    echo -e "  ${YELLOW}Generating G-code: $gcode_file${NC}"

    # Build settings arguments from profile
    local settings_args
    settings_args=$(build_settings_args "$profile_file")

    # Run CuraEngine
    local cmd="$curaengine slice -j \"$definition\" $settings_args -l \"$stl_file\" -o \"$gcode_file\""

    if eval "$cmd" 2>&1 | tail -5; then
        if [ -f "$gcode_file" ] && [ -s "$gcode_file" ]; then
            echo -e "  ${GREEN}G-code generated successfully${NC}"
            ls -lh "$gcode_file"
        else
            echo -e "  ${RED}Failed to generate G-code (empty or missing output)${NC}"
            return 1
        fi
    else
        echo -e "  ${RED}CuraEngine failed${NC}"
        return 1
    fi

    echo ""
}

# ---------- Parse Arguments ----------

while [ $# -gt 0 ]; do
    case "$1" in
        --profile)
            PROFILE="$2"
            shift 2
            ;;
        --definition)
            PRINTER_DEF="$2"
            shift 2
            ;;
        --all)
            PROCESS_ALL=true
            shift
            ;;
        --help|-h)
            usage
            exit 0
            ;;
        -*)
            echo -e "${RED}Unknown option: $1${NC}"
            usage
            exit 1
            ;;
        *)
            STL_FILES+=("$1")
            shift
            ;;
    esac
done

# ---------- Validate Requirements ----------

# Find CuraEngine
CURA_BIN=$(find_curaengine) || {
    echo -e "${RED}Error: CuraEngine is not installed${NC}"
    echo "Please install CuraEngine:"
    echo "  - Ubuntu/Debian: sudo apt-get install curaengine"
    echo "  - macOS: brew install curaengine"
    echo "  - Snap: sudo snap install cura-slicer"
    echo "  - Or download from: https://github.com/Ultimaker/CuraEngine"
    exit 1
}

echo -e "${BLUE}CuraEngine: ${CURA_BIN}${NC}"

# Validate profile
PROFILE_FILE="$PROFILES_DIR/$PROFILE.cfg"
if [ ! -f "$PROFILE_FILE" ]; then
    echo -e "${RED}Error: Profile not found: $PROFILE_FILE${NC}"
    echo "Available profiles:"
    for cfg in "$PROFILES_DIR"/*.cfg; do
        if [ -f "$cfg" ]; then
            echo "  $(basename "$cfg" .cfg)"
        fi
    done
    exit 1
fi

echo -e "${BLUE}Profile: ${PROFILE} (${PROFILE_FILE})${NC}"

# Find printer definition
DEF_FILE=$(find_printer_definition) || {
    echo -e "${RED}Error: No printer definition found${NC}"
    echo "Provide a printer definition using one of:"
    echo "  1. Place printer.def.json in profiles/ directory"
    echo "  2. Set CURA_DEFINITION environment variable"
    echo "  3. Use --definition <path> flag"
    echo "  4. Install CuraEngine system package with definitions"
    exit 1
}

echo -e "${BLUE}Printer definition: ${DEF_FILE}${NC}"
echo ""

# ---------- Collect STL Files ----------

if [ "$PROCESS_ALL" = true ]; then
    while IFS= read -r stl_file; do
        STL_FILES+=("$stl_file")
    done < <(find "$REPO_ROOT" -name "*.stl" -not -path "*/.git/*" -not -path "*/docs/*" | sort)
fi

if [ ${#STL_FILES[@]} -eq 0 ]; then
    echo -e "${YELLOW}No STL files specified${NC}"
    echo "Usage: $(basename "$0") [--profile <name>] [--all] [stl_file ...]"
    exit 0
fi

echo -e "${GREEN}Processing ${#STL_FILES[@]} STL file(s) with profile '${PROFILE}'${NC}"
echo ""

# ---------- Process Files ----------

success_count=0
fail_count=0

for stl_file in "${STL_FILES[@]}"; do
    if process_stl_file "$stl_file" "$CURA_BIN" "$DEF_FILE" "$PROFILE_FILE" "$PROFILE"; then
        ((success_count++))
    else
        ((fail_count++))
    fi
done

# ---------- Summary ----------

echo "============================================================"
echo -e "${GREEN}Completed: ${success_count} succeeded${NC}"
if [ "$fail_count" -gt 0 ]; then
    echo -e "${RED}Failed: ${fail_count}${NC}"
    exit 1
fi
echo -e "${GREEN}All files processed successfully${NC}"
