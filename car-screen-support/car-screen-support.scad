// ============================
// Car Screen Support (Parametric)
// ============================

// ---------- Parameters ----------
support_height = 25;        // mm - vertical height (your hair clip replacement)
dash_thickness = 18;        // mm - thickness of dashboard edge
clip_depth     = 25;        // mm - how deep the clip grabs
wall_thickness = 3;         // mm - structural thickness

screen_width   = 90;        // mm - width of screen base
screen_depth   = 12;        // mm - how much the screen rests on
tilt_angle     = 10;        // degrees - backward tilt

base_width     = screen_width + 10;
fillet_radius  = 2;

// ---------- Quality ----------
$fn = 64;

// ============================
// Main Assembly
// ============================
union() {
    dashboard_clip();
    vertical_support();
    screen_saddle();
}

// ============================
// Dashboard Clip
// ============================
module dashboard_clip() {
    difference() {
        // Outer shape
        cube([
            base_width,
            clip_depth,
            dash_thickness + wall_thickness
        ]);

        // Inner cutout
        translate([wall_thickness, 0, wall_thickness])
            cube([
                base_width - 2 * wall_thickness,
                clip_depth,
                dash_thickness
            ]);
    }
}

// ============================
// Vertical Support
// ============================
module vertical_support() {
    translate([0, clip_depth - wall_thickness, dash_thickness])
        cube([
            base_width,
            wall_thickness,
            support_height
        ]);
}

// ============================
// Screen Saddle
// ============================
module screen_saddle() {
    translate([
        (base_width - screen_width) / 2,
        clip_depth - wall_thickness,
        dash_thickness + support_height
    ])
    rotate([-tilt_angle, 0, 0])
        cube([
            screen_width,
            screen_depth,
            wall_thickness * 2
        ]);
}