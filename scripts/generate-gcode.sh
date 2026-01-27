#!/bin/bash

# ============================================================
# Generate G-code files from STL models using CuraEngine
# ============================================================
# This script slices STL files into G-code using CuraEngine
# with filament profiles stored in the profiles/ directory.
#
# Supports both .cfg (key=value) and .curaprofile (Cura export)
# profile formats.
#
# Requirements: CuraEngine must be installed
# Usage: ./scripts/generate-gcode.sh [options] [stl_file ...]
#
# Options:
#   --profile <name>      Filament profile (default: pla-plus)
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
PROFILE="pla-plus"
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
    echo "  --profile <name>      Filament profile from profiles/ dir (default: pla-plus)"
    echo "  --definition <path>   Path to printer definition JSON"
    echo "  --all                 Process all STL files in repository"
    echo "  --help                Show this help message"
    echo ""
    echo "Available profiles (.cfg):"
    if [ -d "$PROFILES_DIR" ]; then
        for cfg in "$PROFILES_DIR"/*.cfg; do
            if [ -f "$cfg" ]; then
                local name
                name=$(basename "$cfg" .cfg)
                local desc
                desc=$(grep -m1 "^#.*Tuned\|^#.*Profile\|^#.*eSUN" "$cfg" 2>/dev/null | sed 's/^#\s*//' || echo "")
                echo "  $name  ($desc)"
            fi
        done
    fi
    echo ""
    echo "Available profiles (.curaprofile):"
    if [ -d "$PROFILES_DIR" ]; then
        for cp in "$PROFILES_DIR"/*.curaprofile; do
            if [ -f "$cp" ]; then
                local cpname
                cpname=$(basename "$cp" .curaprofile)
                echo "  $cpname"
            fi
        done
    fi
    echo ""
    echo "Examples:"
    echo "  $(basename "$0") model.stl"
    echo "  $(basename "$0") --profile petg project/model.stl"
    echo "  $(basename "$0") --profile petg-cf --all"
    echo "  $(basename "$0") --all"
}

find_curaengine() {
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

    local system_paths=(
        "/usr/share/curaengine/fdmprinter.def.json"
        "/usr/share/cura-engine/fdmprinter.def.json"
        "/usr/share/cura/resources/definitions/fdmprinter.def.json"
        "/snap/cura-slicer/current/usr/share/cura/resources/definitions/fdmprinter.def.json"
    )

    for def_path in "${system_paths[@]}"; do
        if [ -f "$def_path" ]; then
            echo "$def_path"
            return 0
        fi
    done

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

# Resolve profile name to a file path
# Checks: .cfg first, then .curaprofile
resolve_profile() {
    local name="$1"

    if [ -f "$PROFILES_DIR/$name.cfg" ]; then
        echo "$PROFILES_DIR/$name.cfg"
        return 0
    fi

    if [ -f "$PROFILES_DIR/$name.curaprofile" ]; then
        echo "$PROFILES_DIR/$name.curaprofile"
        return 0
    fi

    return 1
}

# Extract settings from a .curaprofile (ZIP) file into a temp .cfg
# Returns path to the extracted .cfg file
extract_curaprofile() {
    local curaprofile="$1"
    local tmpdir
    tmpdir=$(mktemp -d)
    local tmpcfg="$tmpdir/extracted.cfg"

    # Extract all files from the ZIP
    unzip -q -o "$curaprofile" -d "$tmpdir" 2>/dev/null

    # Parse [values] sections from all extracted files, merge into one .cfg
    # The global file (without "extruder") has the main settings
    # The extruder file has per-extruder overrides
    {
        echo "# Extracted from: $(basename "$curaprofile")"
        for f in "$tmpdir"/*; do
            [ -f "$f" ] || continue
            local in_values=false
            while IFS= read -r line; do
                if [[ "$line" == "[values]" ]]; then
                    in_values=true
                    continue
                fi
                if [[ "$line" == "["* ]]; then
                    in_values=false
                    continue
                fi
                if [ "$in_values" = true ] && [ -n "$line" ]; then
                    echo "$line"
                fi
            done < "$f"
        done
    } | sort -u > "$tmpcfg"

    echo "$tmpcfg"
}

# Build settings args array from a profile file (.cfg or extracted .curaprofile)
# Populates the global SETTINGS_ARGS array
build_settings_args() {
    local profile_file="$1"
    SETTINGS_ARGS=()

    while IFS= read -r line; do
        # Remove comments and trim whitespace
        line="${line%%#*}"
        line="$(echo "$line" | xargs 2>/dev/null || echo "")"
        if [ -z "$line" ]; then
            continue
        fi

        # Parse key = value
        if [[ "$line" =~ ^([a-zA-Z_][a-zA-Z0-9_]*)\ *=\ *(.+)$ ]]; then
            local key="${BASH_REMATCH[1]}"
            local value
            value="$(echo "${BASH_REMATCH[2]}" | xargs)"
            SETTINGS_ARGS+=("-s" "${key}=${value}")
        fi
    done < "$profile_file"
}

# ---------- Process a Single STL File ----------

process_stl_file() {
    local stl_file="$1"
    local curaengine="$2"
    local definition="$3"
    local profile_name="$4"

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

    # Run CuraEngine with settings from the global SETTINGS_ARGS array
    if "$curaengine" slice \
        -j "$definition" \
        "${SETTINGS_ARGS[@]}" \
        -l "$stl_file" \
        -o "$gcode_file" 2>&1 | tail -5; then
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

# Resolve profile (supports .cfg and .curaprofile)
PROFILE_FILE=$(resolve_profile "$PROFILE") || {
    echo -e "${RED}Error: Profile not found: $PROFILE${NC}"
    echo "Looked for: profiles/$PROFILE.cfg or profiles/$PROFILE.curaprofile"
    echo ""
    echo "Available profiles:"
    for cfg in "$PROFILES_DIR"/*.cfg; do
        [ -f "$cfg" ] && echo "  $(basename "$cfg" .cfg)"
    done
    for cp in "$PROFILES_DIR"/*.curaprofile; do
        [ -f "$cp" ] && echo "  $(basename "$cp" .curaprofile)"
    done
    exit 1
}

# If it's a .curaprofile, extract the settings to a temp .cfg
CLEANUP_TMPDIR=""
if [[ "$PROFILE_FILE" == *.curaprofile ]]; then
    echo -e "${BLUE}Profile: ${PROFILE} (${PROFILE_FILE}) [curaprofile]${NC}"
    echo -e "${YELLOW}Extracting settings from Cura profile...${NC}"
    PROFILE_FILE=$(extract_curaprofile "$PROFILE_FILE")
    CLEANUP_TMPDIR=$(dirname "$PROFILE_FILE")
else
    echo -e "${BLUE}Profile: ${PROFILE} (${PROFILE_FILE})${NC}"
fi

# Build settings from profile
SETTINGS_ARGS=()
build_settings_args "$PROFILE_FILE"
echo -e "${BLUE}Loaded ${#SETTINGS_ARGS[@]} setting arguments${NC}"

# Clean up temp files if needed
if [ -n "$CLEANUP_TMPDIR" ]; then
    rm -rf "$CLEANUP_TMPDIR"
fi

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
    if process_stl_file "$stl_file" "$CURA_BIN" "$DEF_FILE" "$PROFILE"; then
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
