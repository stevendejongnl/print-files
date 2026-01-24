// =====================================================
// Spigen GaN 65w charger PD2101 – Vertical Charger Mount
// =====================================================

// ---------------- Charger ----------------
charger_w = 40.4;
charger_d = 40.4;
charger_h = 75.0;
tolerance = 0.6;

// ---------------- Geometry ----------------
wall        = 4;
lip_height  = 6;
lip_depth   = 12;
chamfer     = 3;

// ---------------- Screws ----------------
screw_d = 4;
head_d  = 8;
head_h  = 2.5;

// ---------------- Derived ----------------
inner_w = charger_w + tolerance;
inner_d = charger_d + tolerance;
inner_h = charger_h;

outer_w = inner_w + wall * 2;
outer_d = inner_d + wall * 2;
outer_h = inner_h + lip_height;

// =====================================================
// Chamfered footprint (vertical edge chamfers)
// =====================================================
module chamfer_rect(w, d, c) {
    polygon([
        [ c, 0 ],
        [ w-c, 0 ],
        [ w, c ],
        [ w, d-c ],
        [ w-c, d ],
        [ c, d ],
        [ 0, d-c ],
        [ 0, c ]
    ]);
}

// =====================================================
// MODEL
// =====================================================
difference() {

    // ---------- OUTER BODY ----------
    linear_extrude(height = outer_h)
        chamfer_rect(outer_w, outer_d, chamfer);

    // ---------- INNER CAVITY ----------
    translate([wall, wall, lip_height])
        cube([inner_w, inner_d, inner_h + 1]);

    // ---------- OPEN BOTTOM (KEEP LIP) ----------
    translate([wall, wall, -1])
        cube([inner_w, inner_d - lip_depth, lip_height + 2]);

    // ---------- TOP CHAMFER ----------
    translate([-1, -1, outer_h - chamfer])
        cube([outer_w + 2, outer_d + 2, chamfer + 1]);

    // ---------- SCREW HOLES (BACK WALL ONLY) ----------
    for (x = [0.35, 0.65]) {

        // Through hole: OUTSIDE -> INSIDE (only wall thickness)
        translate([outer_w * x, outer_d + 0.01, outer_h * 0.65])
            rotate([90,0,0])
                cylinder(
                    d = screw_d,
                    h = wall + 0.5,
                    $fn = 40
                );

        // Counterbore: INSIDE -> OUTSIDE
        translate([outer_w * x, outer_d - wall - 0.01, outer_h * 0.65])
            rotate([-90,0,0])
                cylinder(
                    d = head_d,
                    h = head_h,
                    $fn = 40
                );
    }
}

// ---------- INTERNAL SUPPORT LIP ----------
translate([wall, outer_d - wall - lip_depth, 0])
    cube([inner_w, lip_depth, lip_height]);