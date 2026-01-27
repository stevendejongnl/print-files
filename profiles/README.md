# Slicing Profiles

This directory contains filament profiles for G-code generation using CuraEngine.

## Included Profiles

| Profile | File | Temp | Bed | Speed | Notes |
|---------|------|------|-----|-------|-------|
| PLA | `pla.cfg` | 200C | 60C | 50mm/s | Standard PLA, good for most prints |
| PETG | `petg.cfg` | 235C | 75C | 40mm/s | Higher temp, less cooling |

## Profile Format

Profiles use a simple key-value format compatible with CuraEngine settings:

```ini
# Comment lines start with #
setting_key = value
```

Each setting maps directly to a CuraEngine parameter. See the [CuraEngine settings list](https://github.com/Ultimaker/CuraEngine/wiki) for all available options.

## Adding a New Profile

1. Copy an existing profile as a starting point:
   ```bash
   cp profiles/pla.cfg profiles/my-filament.cfg
   ```

2. Edit the settings for your filament type

3. Use the profile with the generation script:
   ```bash
   ./scripts/generate-gcode.sh --profile my-filament model.stl
   ```

## Using Your Cura Profiles

If you have profiles configured in Cura (GUI), you can extract the settings:

1. Open Cura
2. Select your desired profile
3. Go to **Help > Show Configuration Folder**
4. Find your profile under `quality_changes/` or `user/`
5. Copy the relevant `[values]` section into a new `.cfg` file here

Alternatively, export your profile:
1. In Cura, go to **Preferences > Profiles > Export**
2. Save as `.curaprofile`
3. This is a ZIP file - extract it and copy the settings into a `.cfg` file

## Printer Definition

CuraEngine requires a printer definition JSON file. The generation script looks for it in this order:

1. `profiles/printer.def.json` (custom definition in this repo)
2. `CURA_DEFINITION` environment variable
3. System CuraEngine definitions (e.g., `/usr/share/curaengine/`)
4. Auto-download of the generic FDM printer definition

To use your specific printer's definition:
- Copy it from your Cura installation's `resources/definitions/` folder
- Place it at `profiles/printer.def.json`

## Common Settings Reference

| Setting | Description | PLA | PETG |
|---------|-------------|-----|------|
| `material_print_temperature` | Nozzle temp (C) | 200 | 235 |
| `material_bed_temperature` | Bed temp (C) | 60 | 75 |
| `layer_height` | Layer height (mm) | 0.2 | 0.2 |
| `speed_print` | Print speed (mm/s) | 50 | 40 |
| `infill_sparse_density` | Infill % | 20 | 20 |
| `cool_fan_speed` | Fan speed % | 100 | 50 |
| `retraction_amount` | Retraction (mm) | 5 | 6.5 |
| `support_enable` | Enable supports | false | false |
