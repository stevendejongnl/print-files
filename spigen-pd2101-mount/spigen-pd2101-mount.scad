/*
Spigen GaN 65W PD2101 – Slide-in Mount
- Rounded exterior
- Left / Right mirrored
- VHB tape + countersunk screws
- Material: PETG recommended
*/

// ================== PARAMETERS ==================
side = "LEFT";            // "LEFT" or "RIGHT"

charger_w = 40.4;         // mm
charger_d = 75.0;
charger_h = 40.4;

tolerance = 0.4;

wall = 3.0;
base_thickness = 5.0;
clip_thickness = 1.4;
clip_height = 8;
clip_angle = 12;

corner_radius = 6;

screw_d = 4.0;
screw_head_d = 8.0;
screw_head_depth = 2.5;

// ================== DERIVED ==================
iw = charger_w + tolerance;
id = charger_d + tolerance;
ih = charger_h + tolerance;

ow = iw + wall * 2;
od = id + wall + 2;          // open back
oh = ih + base_thickness;

mirror_x = (side == "RIGHT") ? 1 : 0;

// ================== MODULES ==================
module rounded_box(x, y, z, r) {
    minkowski() {
        cube([x - 2*r, y - 2*r, z - 2*r]);
        sphere(r = r, $fn=32);
    }
}

module countersunk_hole(x, y) {
    translate([x, y, oh/2])
        rotate([90,0,0]) {
            cylinder(d=screw_d, h=20, $fn=32);
            translate([0,0,-screw_head_depth])
                cylinder(d=screw_head_d, h=screw_head_depth, $fn=32);
        }
}

// ================== MODEL ==================
mirror([mirror_x,0,0])
difference() {

    // Outer shell
    rounded_box(ow, od, oh, corner_radius);

    // Inner cavity (slide-in)
    translate([wall, wall, base_thickness])
        cube([iw, id + 10, ih]);

    // Open back
    translate([-1, od - wall, -1])
        cube([ow + 2, wall + 5, oh + 2]);

    // Screw holes
    countersunk_hole(ow/2, wall + 10);
    countersunk_hole(ow/2, wall + 30);
}

// ================== FLEX CLIP ==================
translate([
    (side == "LEFT") ? wall : ow - wall - clip_thickness,
    wall - 0.1,
    base_thickness + 5
])
rotate([0, (side == "LEFT") ? -clip_angle : clip_angle, 0])
cube([clip_thickness, clip_height, 18]);