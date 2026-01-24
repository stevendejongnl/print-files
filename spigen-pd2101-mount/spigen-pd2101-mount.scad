// =====================================================
// Spigen PD2101 – Vertical Charger Mount
// 4 walls, open bottom, lip + screws on same side
// Subtle top chamfer only
// =====================================================

side = "LEFT"; // "LEFT" or "RIGHT"

// Charger (standing)
charger_width  = 40.4;
charger_depth  = 40.4;
charger_height = 75.0;

tolerance = 0.6;

// Geometry
wall       = 4;
lip_height = 6;
lip_depth  = 12;
top_chamfer = 2.5;   // subtle, visible, calm

// Screws
screw_d      = 4;
screw_head_d = 8;
screw_head_h = 2.5;

// Derived
inner_w = charger_width  + tolerance;
inner_d = charger_depth  + tolerance;
inner_h = charger_height;

outer_w = inner_w + wall * 2;
outer_d = inner_d + wall * 2;
total_h = inner_h + lip_height;

mirror_x = (side == "RIGHT") ? 1 : 0;

// ================= Mount wall =================
module mount_wall() {
    difference() {
        cube([wall, outer_d, total_h]);

        for (ypos = [0.35, 0.65]) {
            translate([wall/2, outer_d*ypos, total_h*0.65])
                rotate([0,90,0]) {
                    cylinder(d=screw_d, h=20, $fn=32);
                    translate([0,0,-screw_head_h])
                        cylinder(d=screw_head_d, h=screw_head_h, $fn=32);
                }
        }
    }
}

// ================= Plain wall =================
module plain_wall(x, y, z) {
    cube([x, y, z]);
}

// ================= Body =================
module body() {
    union() {

        // Mount side
        mount_wall();

        // Opposite side
        translate([outer_w - wall, 0, 0])
            plain_wall(wall, outer_d, total_h);

        // Back
        translate([wall, outer_d - wall, 0])
            plain_wall(inner_w, wall, total_h);

        // Front
        translate([wall, 0, 0])
            plain_wall(inner_w, wall, total_h);

        // Internal lip (mount side only)
        translate([wall, wall, 0])
            cube([lip_depth, inner_d, lip_height]);
    }
}

// ================= Final model =================
mirror([mirror_x,0,0])
difference() {

    body();

    // Subtle top chamfer ring
    translate([-1, -1, total_h - top_chamfer])
        cube([outer_w + 2, outer_d + 2, top_chamfer + 1]);
}