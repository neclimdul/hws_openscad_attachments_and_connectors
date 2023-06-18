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

module wall_relief(tolerance = tolerance)
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
    _hex_prism(d = main_outer_distance, h = insert_height, tolerance = tolerance);
    _hex_prism(d = lip_outer_distance, h = lip_height);
    _insert_snaps(tolerance);
}

module _insert_snaps(tolerance = tolerance)
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
                    translate([ 0, 0, insert_height - preview_bump ])
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
    _hex_prism(d = main_inner_distance, h = insert_height + preview_bump, tolerance = -tolerance);
}

module _hex_prism(d, h, tolerance = tolerance)
{
    // "cylinder" with 6 sides is our prism
    circular_radius = d / sqrt(3) * 2;
    cylinder(d = circular_radius - tolerance * 2, h = h, $fn = 6);
}

module _connector(structure, rotation, p, p2 = [], reversed = false)
{
    x_pos = p[0];
    y_pos = p[1];
    if (_check_connector_location(structure, p))
    {
        rotate(rotation) translate([ (lip_outer_distance / 2), -main_outer_side / 2, 0 ])
        {
            // TODO combine cube and fill triangle into a polygon.
            cube([ 1.1, main_outer_side, connector_height ]);
            if (p2 != [] && _check_connector_location(structure, p2))
            {
                // Draw additional point.
                // TODO use reversed to draw second connector fill.
                translate([0, main_outer_side, 0]) linear_extrude(height = connector_height)
                {
                    polygon(points = [ [ 0, 0 ], [ 1.1, 0 ], [ .55, 1.1 * sin(60) ] ], paths = [[ 0, 1, 2 ]]);
                }
                echo("test");
            }
            else
            {
                echo(p2);
            }
        }
    }
}

function _check_connector_location(structure, p) =
    let(x_pos = p[0], y_pos = p[1]) x_pos >= 0 && y_pos >= 0 && y_pos < len(structure) &&
    x_pos < len(structure[y_pos]) && structure[y_pos][x_pos] > 0;

module _wall_reliefs(tolerance = tolerance)
{
    for (i = [0:5])
    {
        rotate([ 0, 0, i * 60 ])
        {
            wall_relief(tolerance);
        }
    }
}