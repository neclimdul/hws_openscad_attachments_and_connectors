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

module _draw_insert(type = 0)
{
    difference()
    {
        _insert_body(tolerance);
        // Remove type specific features.
        _draw_features(type);
        // Add wall reliefs.
        _wall_reliefs(tolerance);
    }
}

module _draw_features(type)
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
            insert_empty_attachment();
        else if (type == 8)
            insert_empty_attachment_countersunk();
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

module _insert_body(tolerance = tolerance)
{
    // Body.
    filet_height = 0.4;
    union()
    {
        difference()
        {
            union()
            {
                _hex_prism(d = main_outer_distance, h = insert_height - filet_height, tolerance = tolerance);
                // Top filet. 19.3(.2), 0.4.
                translate(v = [ 0, 0, insert_height - filet_height ])
                    _hex_prism(d = main_outer_distance, d2 = 19.3, h = filet_height, tolerance = tolerance);
            }
            // Filets.
            for (i = [0:5])
            {
                rotate([ 0, 0, i * 60 - 30 ])
                {
                    translate([ -.5, hex_to_circular_radius(main_outer_distance) / 2 - 0.1 - tolerance, lip_height ])
                        cube([ 1, 1, full_height - lip_height ]);
                }
            }
        }
        _hex_prism(d = lip_outer_distance, h = lip_height);
        // TODO filet base. Requires following out edge. Reverse connector check?
        _insert_snaps(tolerance, fillet_size = filet_height);
    }
}

module _insert_snaps(tolerance = tolerance, fillet_size = 0)
{
    // Add snaps.
    for (i = [0:5])
    {
        rotate([ 0, 0, i * 60 ])
        {
            translate([ 0, main_outer_distance / 2 - tolerance, 0 ])
            {
                hull()
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

module insert_empty_attachment()
{
    union()
    {
        // TODO supportless hack
        _hex_prism(d = main_inner_distance, h = 6, tolerance = -tolerance);
        cylinder(h = insert_height + 2 * preview_bump, r = 1.75);
    }
}

module insert_empty_attachment_countersunk()
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
        // Filet
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
        // Filet
        translate(v = [ 0, 0, 9.7 - preview_bump ]) cylinder(h = 0.3 + 3 * preview_bump, r1 = 2.55, r2 = 2.85);
    }
}

module _hex_prism(d, d2 = 0, h, tolerance = tolerance)
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

module _connector(structure, rotation, p, p2 = [], reversed = false)
{
    if (_check_connector_location(structure, p))
    {
        s1 = (lip_outer_distance / 2) - 0.001;
        s2 = -main_outer_side / 2;
        s3 = s1 + 1.102;
        s4 = -s2;
        s5 = s1 + .55005;
        s6 = (p2 != [] && _check_connector_location(structure, p2)) ? s4 + (1.101 * sin(60)) : s4;
        rotate(rotation) mirror(v = [ 0, reversed ? 1 : 0, 0 ]) linear_extrude(height = connector_height)
        {
            polygon(points = [[s1, s2], [s1, s4], [s5, s6], [s3, s4], [s3, s2]]);
        }
    }
}

function _check_connector_location(structure, p) =
    let(x_pos = p[0], y_pos = p[1]) x_pos >= 0 && y_pos >= 0 && y_pos < len(structure) &&
    x_pos < len(structure[y_pos]) && structure[y_pos][x_pos] > 0;
function hex_to_circular_radius(d) = d / sqrt(3) * 2;