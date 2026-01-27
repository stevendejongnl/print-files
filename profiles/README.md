# Slicing Profiles

This directory contains filament profiles for G-code generation using CuraEngine.

## Included Profiles

| Profile | File | Filament | Temp | Bed | Speed | Notes |
|---------|------|----------|------|-----|-------|-------|
| pla-plus | `pla-plus.cfg` | eSUN PLA+ | 210C | 60C | 75mm/s | Quality preset, Aquila tuned |
| petg | `petg.cfg` | eSUN PETG | 245C | 80C | 85mm/s | Fast preset, Aquila tuned |
| petg-cf | `petg-cf.cfg` | eSUN PETG-CF | 255C | 85C | 65mm/s | Precision preset, Aquila tuned |

All profiles are tuned for a **Voxelab Aquila** with 0.4mm nozzle at 0.2mm layer height.

## Cura Source Profiles

The original `.curaprofile` exports from Cura are also stored here for reference:

- `esun pla plus aquila.curaprofile`
- `esun petg aquila.curaprofile`
- `esun petg cf aquila.curaprofile`

These can be imported directly into Cura via **Preferences > Profiles > Import**.

## Profile Format

### .cfg files (recommended for CuraEngine)

Simple key-value format with CuraEngine settings:

```ini
# Comment lines start with #
material_print_temperature = 210
speed_print = 75
layer_height = 0.2
```

### .curaprofile files (Cura exports)

ZIP archives exported from Cura. The generate-gcode script can read these directly - it extracts the `[values]` section automatically.

## Usage

```bash
# Use default profile (pla-plus)
./scripts/generate-gcode.sh model.stl

# Use a specific profile
./scripts/generate-gcode.sh --profile petg model.stl
./scripts/generate-gcode.sh --profile petg-cf --all

# Use a .curaprofile directly (by name without extension)
./scripts/generate-gcode.sh --profile "esun petg aquila" model.stl
```

## Adding a New Profile

### From Cura

1. Export your profile from Cura: **Preferences > Profiles > Export**
2. Place the `.curaprofile` file in this directory
3. Optionally create a `.cfg` file with the extracted settings for faster loading

### From scratch

1. Copy an existing `.cfg` file:
   ```bash
   cp profiles/pla-plus.cfg profiles/my-filament.cfg
   ```
2. Edit the settings for your filament
3. Use with: `./scripts/generate-gcode.sh --profile my-filament model.stl`

## Printer Definition

CuraEngine requires a printer definition JSON file. The generation script looks for it in this order:

1. `profiles/printer.def.json` (custom definition in this repo)
2. `CURA_DEFINITION` environment variable
3. System CuraEngine definitions (e.g., `/usr/share/curaengine/`)
4. Auto-download of the generic FDM printer definition

To use your specific printer's definition, copy it from your Cura installation's `resources/definitions/` folder to `profiles/printer.def.json`.

## Common Settings Reference

| Setting | Description | PLA+ | PETG | PETG-CF |
|---------|-------------|------|------|---------|
| `material_print_temperature` | Nozzle temp (C) | 210 | 245 | 255 |
| `material_bed_temperature` | Bed temp (C) | 60 | 80 | 85 |
| `speed_print` | Print speed (mm/s) | 75 | 85 | 65 |
| `speed_wall_0` | Outer wall speed (mm/s) | 48 | 45 | 38 |
| `acceleration_print` | Acceleration (mm/s2) | 2400 | 1800 | 1500 |
| `retraction_amount` | Retraction (mm) | 5.0 | 6.5 | 7.0 |
| `cool_fan_speed` | Fan speed % | 25 | 12 | 8 |
| `material_pressure_advance` | Pressure advance | 0.035 | 0.052 | 0.068 |
