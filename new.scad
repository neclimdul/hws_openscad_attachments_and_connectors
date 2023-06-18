include <hws_insert_util.scad>

/* [Setup Parameters] */
$fa = 8;
$fs = 0.25;

/* [Options] */
tolerance = 0;
decoration_depth = 0;

// TODO
//  - Filet the inner component
//  - Polygon corner
//  - Variations

// structure = [ [ 0, 0, 1, 0 ], [ 0, 1, 1, 0 ], [ 1, 0, 0, 1 ] ];
// structure = [ [ 0, 1, 0 ], [ 1, 1 ], [ 1, 1, 0 ] ];
// structure = [ [ 2, 1, 1 ], [ 1, 2, 1 ] ];
// Torture test.
structure = [ [ 0, 1, 2, 3, 0 ], [ 0, 4, 5, 6, 0 ], [ 7, 8, 0, 9 ], [ 1, 0, 0, 1 ], [ 1, 1, 1, 1 ], [ 1, 1, 1, 1 ] ];
// Alt thing.
// structure = [ [ 1, 1 ], [1], [1] ];

// color("orange");
insert_plug_adv(structure);

module insert_plug_adv(structure)
{
    x1 = 25.98;
    x2 = main_outer_side;
    y_distance = 47.2 / 4;
    // Calculated horizontal separation based on 1.1 wall separation.
    h_s = 0.9535;
    y_length = len(structure);
    for (y_pos = [0:y_length - 1])
    {
        y_even = y_pos % 2;
        y = y_pos * y_distance;
        x_length = len(structure[y_pos]);
        x_offset = y_even * (x1 - 6.495 + h_s);
        for (x_pos = [0:x_length - 1])
        {
            x = x_pos * (x1 + x2 + 2 * h_s) + y_even * x_offset;
            x_even = x_pos % 2;
            position = [ x, y, 0 ];
            if (structure[y_pos][x_pos] != 0)
            {
                translate(v = position) union()
                {
                    _draw_insert(structure[y_pos][x_pos]);
                    p1 = [ x_pos + y_even, y_pos + 1 ];
                    p2 = [ x_pos, y_pos + 2 ];
                    p3 = [ x_pos + y_even - 1, y_pos + 1 ];
                    color("purple") _connector(structure, 30, p1, p2);
                    color("red") _connector(structure, 90, p2);
                    // TODO add reversed connector.
                    color("blue") _connector(structure, 150, p3);
                }
            }
        }
    }
}

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
    if (type == 2)
    {
        // intentionaly empty
    }
    else
        _insert_insert();
}