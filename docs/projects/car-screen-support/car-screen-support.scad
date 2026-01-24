// ============================
// Screen Support Block with U-Cradle
// ============================

// ---------- Parameters ----------
block_width_top    = 20;   // mm
block_width_bottom = 30;   // mm
block_depth        = 22;   // mm
block_height       = 25;   // mm

cradle_width       = 14;   // mm - inside width for screen edge
cradle_depth       = 8;    // mm
cradle_wall        = 2;    // mm
cradle_height      = 4;    // mm

rounding           = 0.8;

// ---------- Quality ----------
$fn = 64;

// ============================
// Main
// ============================
difference() {
    union() {
        tapered_block();
        cradle_walls();
    }
    cradle_cutout();
}

// ============================
// Tapered Base
// ============================
module tapered_block() {
    hull() {
        translate([
            -block_width_bottom / 2,
            -block_depth / 2,
            0
        ])
        cube([block_width_bottom, block_depth, 1]);

        translate([
            -block_width_top / 2,
            -block_depth / 2,
            block_height
        ])
        cube([block_width_top, block_depth, 1]);
    }
}

// ============================
// Cradle Walls
// ============================
module cradle_walls() {

    // Left wall
    translate([
        -cradle_width / 2 - cradle_wall,
        -cradle_depth / 2,
        block_height
    ])
    cube([cradle_wall, cradle_depth, cradle_height]);

    // Right wall
    translate([
        cradle_width / 2,
        -cradle_depth / 2,
        block_height
    ])
    cube([cradle_wall, cradle_depth, cradle_height]);

    // Back wall
    translate([
        -cradle_width / 2 - cradle_wall,
        cradle_depth / 2 - cradle_wall,
        block_height
    ])
    cube([cradle_width + 2 * cradle_wall, cradle_wall, cradle_height]);
}

// ============================
// Cradle Cutout
// ============================
module cradle_cutout() {
    translate([
        -cradle_width / 2,
        -cradle_depth / 2,
        block_height
    ])
    cube([cradle_width, cradle_depth, cradle_height + 0.1]);
}