include <hws_insert_util.scad>

/* [Setup Parameters] */
$fa = 8;
$fs = 0.25;

/* [Options] */
tolerance = 0;
decoration = true;

/**
 * The structure array documents the layout of individual
 *
 * 0 - No insert
 * 1 - Empty center
 * 2 - Solid
 * 3 - Countersunk
 * 4 - m3
 * 5 - m4
 * 6 - m5
 * 7 - Empty countersunk
 * 8 - Empty countersunk 85°
 * 9 - ...
 */
// structure = [ [ 0, 0, 1, 0 ], [ 0, 1, 1, 0 ], [ 1, 0, 0, 1 ] ];
// structure = [ [ 0, 1, 0 ], [ 1, 1 ], [ 1, 1, 0 ] ];
// structure = [ [ 2, 1, 1 ], [ 1, 2, 1 ] ];
// Torture test.
// structure = [ [ 0, 1, 2, 3, 0 ], [ 0, 4, 5, 6, 0 ], [ 7, 8, 0, 9 ], [ 1, 0, 0, 1 ], [ 1, 1, 1, 1 ], [ 1, 1, 1, 1 ] ];
// Alt thing.
structure = [ [ 1, 1 ], [1], [1] ];

// color("orange");
insert_plug_adv(structure);

module insert_plug_adv(structure)
{
    for (y_pos = [0:len(structure) - 1])
    {
        for (x_pos = [0:len(structure[y_pos]) - 1])
        {
            if (structure[y_pos][x_pos] != 0)
            {
                _draw_insert(structure, x_pos, y_pos, tolerance, decoration);
            }
        }
    }
}