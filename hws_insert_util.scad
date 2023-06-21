/* Constants */
lip_outer_distance = 22.5;
main_outer_distance = 19.7;
main_outer_side = 12.99;
main_inner_distance = 13.4;
insert_height = 10;
lip_height = 2.5;
full_height = 46.1 / 2;

wall_relief_height = 3.5;
wall_side_relief_size = 1;
wall_top_relief_size = 0.8;
wall_relief_length = 8;
wall_top_radius = 8.25;

snap_size = 0.5;
snap_width = 2;

connector_height = lip_height;

// A tiny addition distance to add to dimensions to help the OpenSCAD preview.
preview_bump = .002;

decoration_depth = 0.3;
decoration_chamfer = decoration_depth / cos(45);

/**
 * Map adjacent quadrants to a point in the structure array.
 *     1
 *  2     0
 *  3     5
 *     4
 */
quadrants_map = [ [ 0, 1 ], [ 0, 2 ], [ -1, 1 ], [ -1, -1 ], [ 0, -2 ], [ 0, -1 ] ];
// map quadrant to angle.
quadrant_angles = [ 30, 90, 150, 210, 270, 330 ];

module _draw_insert(structure, x_pos, y_pos, tolerance = 0, decorate = true)
{
    x1 = 25.98;
    x2 = main_outer_side;
    y_distance = 11.8; // 47.2 / 4;
    // Calculated horizontal separation based on 1.1mm wall separation.
    h_s = 0.9535;

    y_even = y_pos % 2;
    x_offset = y_even * (x1 - 6.495 + h_s);
    x = x_pos * (x1 + x2 + 2 * h_s) + y_even * x_offset;
    y = y_pos * y_distance;
    position = [ x, y, 0 ];
    translate(v = position) union()
    {
        difference()
        {
            _insert_body(tolerance, decorate = decorate);
            // Remove type specific features.
            _draw_features(structure[y_pos][x_pos], tolerance);
            // Add wall reliefs.
            _wall_reliefs(tolerance);
        }
        // Connect plugs.
        translate(v = [ 0, 0, decorate ? decoration_depth : 0 ])
        {
            color("red") _connector2(structure, [ x_pos, y_pos ], 0, decorate = decorate);
            color("green") _connector2(structure, [ x_pos, y_pos ], 1, decorate = decorate);
            color("blue") _connector2(structure, [ x_pos, y_pos ], 2, decorate = decorate);
        }
    }
}

module _draw_features(type, tolerance = 0)
{
    translate(v = [ 0, 0, -preview_bump ])
    {
        if (type == 2)
        {
            // intentionaly empty to be solid.
        }
        else if (type == 3)
            _insert_countersunk();
        else if (type == 4)
            _insert_m3();
        else if (type == 5)
            insert_m4();
        else if (type == 6)
            insert_m5();
        else if (type == 7)
            insert_empty_attachment(tolerance = tolerance);
        else if (type == 8)
            insert_empty_attachment_countersunk(tolerance = tolerance);
        else
            _insert_insert();
    }
}

module _wall_reliefs(tolerance = tolerance)
{
    for (i = [0:5])
    {
        rotate([ 0, 0, i * 60 ])
        {
            _wall_relief(tolerance);
        }
    }
}

module _wall_relief(tolerance = tolerance)
{
    translate([ -wall_relief_length / 2, wall_top_radius, insert_height - wall_relief_height ])
    {
        // Vertical.
        translate([ 0, -tolerance, 0 ])
        {
            cube([ wall_relief_length, wall_top_relief_size, wall_relief_height + preview_bump ]);
        }
        // Horizontal.
        side_relief_depth = (main_outer_distance - (2 * wall_top_radius)) / 2;
        cube([ wall_relief_length, side_relief_depth + preview_bump, wall_side_relief_size ]);
    }
}

module _insert_body(tolerance = tolerance, decorate = decorate)
{
    // Body.
    chamfer_height = 0.4;
    difference()
    {
        union()
        {
            _hex_prism(d = main_outer_distance, h = insert_height - chamfer_height, tolerance = tolerance);
            // Top chamfer. 19.3(.2), 0.4.
            translate(v = [ 0, 0, insert_height - chamfer_height ])
                _hex_prism(d = main_outer_distance, d2 = 19.3, h = chamfer_height, tolerance = tolerance);
            _hex_prism(d = lip_outer_distance, h = lip_height);
            _insert_snaps(tolerance, fillet_size = chamfer_height);
        }
        for (i = [0:0])
        {
            rotate([ 0, 0, i * 60 ])
            {
                // Corner chamfer.
                translate([
                    hex_to_circular_radius(main_outer_distance) / 2 - 0.1 - tolerance, -.5, lip_height + preview_bump
                ]) cube([ 1, 1, full_height - lip_height ]);
                // Base chamfer.
                // TODO: Requires following out edge. Reverse connector check?
                // if (_check_location_populated_point())
                translate(v = [ 0, lip_outer_distance / 2, 0 ]) rotate([ 45, 0, 0 ])
                {
                    cube(size = [ lip_outer_distance, decoration_chamfer, decoration_chamfer ], center = true);
                }
            }
        }
    }
}

module _insert_snaps(tolerance = tolerance, fillet_size = 0)
{
    // Add snaps.
    for (i = [0:5])
    {
        rotate([ 0, 0, i * 60 ]) translate([ 0, main_outer_distance / 2 - tolerance, 0 ]) hull()
        {
            translate([ 0, 0, (insert_height - wall_relief_height) + wall_side_relief_size + snap_size ])
            {
                rotate([ 0, 90, 0 ])
                {
                    cylinder(r = snap_size, h = snap_width, center = true, $fn = 20);
                }
            }
            translate([ 0, 0, insert_height - preview_bump - fillet_size ])
            {
                rotate([ 0, 90, 0 ])
                {
                    cylinder(r = preview_bump, h = snap_width, center = true, $fn = 20);
                }
            }
        }
    }
}

module _insert_insert(tolerance = 0)
{
    _hex_prism(d = main_inner_distance, h = insert_height + 2 * preview_bump, tolerance = -tolerance);
}

module _insert_countersunk()
{
    union()
    {
        cylinder(h = 6, r = 5);
        // 135°
        translate(v = [ 0, 0, 6 ]) cylinder(h = 3.25, r1 = 5, r2 = 1.75);
        cylinder(h = insert_height + 2 * preview_bump, r = 1.75);
    }
}

module insert_empty_attachment(tolerance = 0)
{
    union()
    {
        // TODO supportless hack
        _hex_prism(d = main_inner_distance, h = 6, tolerance = -tolerance);
        cylinder(h = insert_height + 2 * preview_bump, r = 1.75);
    }
}

module insert_empty_attachment_countersunk(tolerance = 0)
{
    union()
    {
        // TODO supportless hack
        _hex_prism(d = main_inner_distance, h = 6.001, tolerance = -tolerance);
        translate(v = [ 0, 0, 6 ]) cylinder(h = 3.25, r1 = 5, r2 = 1.75);
        cylinder(h = insert_height + 2 * preview_bump, r = 1.75);
    }
}

module _insert_m3()
{
    union()
    {
        _hex_prism(d = 11.4, h = 3);
        // + 3.3
        _hex_prism(d = 5.8, h = 6.3);
        cylinder(h = insert_height + 2 * preview_bump, r = 1.6);
    }
}

module insert_m4()
{
    union()
    {
        _hex_prism(d = 11.4, h = 3);
        // + 4
        _hex_prism(d = 7.1, h = 7);
        // + 2.7
        cylinder(h = 9.7, r = 2.1);
        // Chamfer
        translate(v = [ 0, 0, 9.7 - preview_bump ]) cylinder(h = 0.3 + 3 * preview_bump, r1 = 2.1, r2 = 2.4);
    }
}

module insert_m5()
{
    union()
    {
        _hex_prism(d = 11.4, h = 3);
        // + 4
        _hex_prism(d = 8.1, h = 7);
        // + 2.7
        cylinder(h = 9.7, r = 2.55);
        // Chamfer
        translate(v = [ 0, 0, 9.7 - preview_bump ]) cylinder(h = 0.3 + 3 * preview_bump, r1 = 2.55, r2 = 2.85);
    }
}

module _hex_prism(d, d2 = 0, h, tolerance = 0)
{
    // "cylinder" with 6 sides is our prism
    circular_radius = hex_to_circular_radius(d);
    if (d2 != 0)
    {
        circular_radius2 = hex_to_circular_radius(d2);
        cylinder(d1 = circular_radius - tolerance * 2, d2 = circular_radius2, h = h, $fn = 6);
    }
    else
    {
        cylinder(d = circular_radius - tolerance * 2, h = h, $fn = 6);
    }
}

module _connector2(structure, current, quadrant, decorate)
{
    if (_check_location_populated_quadrant(structure, current, quadrant))
    {
        s1 = (lip_outer_distance / 2) - 0.001;
        s2 = -main_outer_side / 2;
        s3 = s1 + 1.102;
        s4 = -s2;
        s5 = s1 + .55005;
        c_height = connector_height - (decorate ? decoration_depth : 0);
        reversed = quadrant == 2 ? true : false;
        // If adjacent location populated, extend into center point.
        s6 = ((quadrant == 0 || quadrant == 2) && _check_location_populated_quadrant(structure, current, 1)) ? s4 + (1.101 * sin(60)) : s4;
        rotate(quadrant_angles[quadrant]) mirror(v = [ 0, reversed ? 1 : 0, 0 ]) linear_extrude(height = c_height)
        {
            polygon(points = [[s1, s2], [s1, s4], [s5, s6], [s3, s4], [s3, s2]]);
        }
    }
}

function _check_location_populated_quadrant(structure, current, quadrant) =
    let(p = add_points(add_points(current, quadrants_map[quadrant]), [ current[1] % 2, 0 ]))
        _check_location_populated_point(structure, p);
function _check_location_populated_point(structure, p) =
    let(x_pos = p[0], y_pos = p[1]) x_pos >= 0 && y_pos >= 0 && y_pos < len(structure) &&
    x_pos < len(structure[y_pos]) && structure[y_pos][x_pos] > 0;
function hex_to_circular_radius(d) = d / sqrt(3) * 2;
function add_points(p1, p2) = [ p1[0] + p2[0], p1[1] + p2[1] ];
