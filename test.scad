include <hws_insert_util.scad>

module assert_point(p1, p2)
{
    assert(p1 == p2, str(p1, " equals ", p2));
}
module assert_quadrant_point(p1, p2, q)
{
    y_even = p2[1] % 2;
    echo("adding ", p2, " to ", quadrants_map[q]);
    echo("odd: ", y_even, " qmod: ", q % 2, " ", q, (q % 2 != (q > 2 ? 1 : 0)), (q % 2 != (q > 2 ? 1 : 0)) ? y_even : 0);
    assert_point(p1, _get_quadrant_point(p2, q));
}

assert_quadrant_point([0, 1], [0,0], 0);
assert_quadrant_point([0, 2], [0,0], 1);
assert_quadrant_point([-1, 1], [0,0], 2);
assert_quadrant_point([-1, -1], [0,0], 3);
assert_quadrant_point([0, -2], [0,0], 4);
assert_quadrant_point([0, -1], [0,0], 5);

assert_quadrant_point([1, 2], [0,1], 0);
assert_quadrant_point([0, 3], [0,1], 1);
assert_quadrant_point([0, 2], [0,1], 2);
assert_quadrant_point([0, 0], [0,1], 3);
assert_quadrant_point([0, -1], [0,1], 4);
assert_quadrant_point([1, 0], [0,1], 5);

assert_quadrant_point([1, 2], [0,1], 0);
assert_quadrant_point([0, 3], [0,1], 1);
assert_quadrant_point([0, 2], [0,1], 2);
assert_quadrant_point([0, 0], [0,1], 3);
assert_quadrant_point([0, -1], [0,1], 4);
assert_quadrant_point([1, 0], [0,1], 5);

// assert([0, 1] == _get_quadrant_point([1,1], 0), "");
// assert([0, 2] == _get_quadrant_point([1,1], 1), "");
// assert([-1, 1] == _get_quadrant_point([1,1], 2), "");
// assert([-1, -1] == _get_quadrant_point([1,1], 3), "");
// assert([0, -2] == _get_quadrant_point([1,1], 4), "");
// assert([0, -1] == _get_quadrant_point([1,1], 5), "");

// Torture test.
structure = [
    [ 0, 1, 2, 3, 0 ],
    [ 2, 4, 5, 6, 0 ],
    [ 7, 8, 0, 9 ],
    [ 1, 0, 0, 1 ],
    [ 1, 1, 1, 1 ],
    [ 1, 1, 1, 1 ]
];


assert(_check_location_populated_quadrant(structure, [0, 0], 0));
assert(_check_location_populated_quadrant(structure, [0, 0], 1));
assert(!_check_location_populated_quadrant(structure, [0, 0], 2));
assert(!_check_location_populated_quadrant(structure, [0, 0], 3));
assert(!_check_location_populated_quadrant(structure, [0, 0], 4));
assert(!_check_location_populated_quadrant(structure, [0, 0], 5));

assert(_check_location_populated_quadrant(structure, [1, 0], 0));
assert(_check_location_populated_quadrant(structure, [1, 0], 1));
assert(_check_location_populated_quadrant(structure, [1, 0], 2));
assert(!_check_location_populated_quadrant(structure, [1, 0], 3));
assert(!_check_location_populated_quadrant(structure, [1, 0], 4));
assert(!_check_location_populated_quadrant(structure, [1, 0], 5));

assert(_check_location_populated_quadrant(structure, [2, 0], 0));
assert(!_check_location_populated_quadrant(structure, [2, 0], 1));
assert(_check_location_populated_quadrant(structure, [2, 0], 2));
assert(!_check_location_populated_quadrant(structure, [2, 0], 3));
assert(!_check_location_populated_quadrant(structure, [2, 0], 4));
assert(!_check_location_populated_quadrant(structure, [2, 0], 5));

assert(_check_location_populated_quadrant(structure, [3, 0], 0));
assert(_check_location_populated_quadrant(structure, [3, 0], 1));
assert(_check_location_populated_quadrant(structure, [3, 0], 2));
assert(!_check_location_populated_quadrant(structure, [3, 0], 3));
assert(!_check_location_populated_quadrant(structure, [3, 0], 4));
assert(!_check_location_populated_quadrant(structure, [3, 0], 5));

/// Row 2
assert(_check_location_populated_quadrant(structure, [0, 1], 0));
assert(_check_location_populated_quadrant(structure, [0, 1], 1));
assert(_check_location_populated_quadrant(structure, [0, 1], 2));
assert(!_check_location_populated_quadrant(structure, [0, 1], 3));
assert(!_check_location_populated_quadrant(structure, [0, 1], 4));
assert(_check_location_populated_quadrant(structure, [0, 1], 5));

assert(!_check_location_populated_quadrant(structure, [1, 1], 0));
assert(!_check_location_populated_quadrant(structure, [1, 1], 1));
assert(_check_location_populated_quadrant(structure, [1, 1], 2));
// Broken
assert(_check_location_populated_quadrant(structure, [1, 1], 3));
assert(!_check_location_populated_quadrant(structure, [1, 1], 4));
assert(_check_location_populated_quadrant(structure, [1, 1], 5));

assert(_check_location_populated_quadrant(structure, [2, 1], 0));
assert(!_check_location_populated_quadrant(structure, [2, 1], 1));
assert(!_check_location_populated_quadrant(structure, [2, 1], 2));
assert(_check_location_populated_quadrant(structure, [2, 1], 3));
assert(!_check_location_populated_quadrant(structure, [2, 1], 4));
assert(_check_location_populated_quadrant(structure, [2, 1], 5));

assert(!_check_location_populated_quadrant(structure, [3, 1], 0));
assert(_check_location_populated_quadrant(structure, [3, 1], 1));
assert(_check_location_populated_quadrant(structure, [3, 1], 2));
assert(_check_location_populated_quadrant(structure, [3, 1], 3));
assert(!_check_location_populated_quadrant(structure, [3, 1], 4));
assert(!_check_location_populated_quadrant(structure, [3, 1], 5));

// Row 3
assert(_check_location_populated_quadrant(structure, [0, 2], 0));
assert(_check_location_populated_quadrant(structure, [0, 2], 1));
assert(!_check_location_populated_quadrant(structure, [0, 2], 2));
assert(!_check_location_populated_quadrant(structure, [0, 2], 3));
assert(!_check_location_populated_quadrant(structure, [0, 2], 4));
assert(_check_location_populated_quadrant(structure, [0, 2], 5));

assert(!_check_location_populated_quadrant(structure, [1, 2], 0));
assert(_check_location_populated_quadrant(structure, [1, 2], 1));
assert(_check_location_populated_quadrant(structure, [1, 2], 2));
assert(_check_location_populated_quadrant(structure, [1, 2], 3));
assert(_check_location_populated_quadrant(structure, [1, 2], 4));
assert(_check_location_populated_quadrant(structure, [1, 2], 5));

assert(!_check_location_populated_quadrant(structure, [2, 2], 0));
assert(_check_location_populated_quadrant(structure, [2, 2], 1));
assert(!_check_location_populated_quadrant(structure, [2, 2], 2));
assert(_check_location_populated_quadrant(structure, [2, 2], 3));
assert(_check_location_populated_quadrant(structure, [2, 2], 4));
assert(_check_location_populated_quadrant(structure, [2, 2], 5));

assert(_check_location_populated_quadrant(structure, [3, 2], 0));
assert(_check_location_populated_quadrant(structure, [3, 2], 1));
assert(!_check_location_populated_quadrant(structure, [3, 2], 2));
assert(_check_location_populated_quadrant(structure, [3, 2], 3));
assert(_check_location_populated_quadrant(structure, [3, 2], 4));
assert(_check_location_populated_quadrant(structure, [3, 2], 5));


// Row 4
assert(_check_location_populated_quadrant(structure, [0, 3], 0));
assert(_check_location_populated_quadrant(structure, [0, 3], 1));
assert(_check_location_populated_quadrant(structure, [0, 3], 2));
assert(_check_location_populated_quadrant(structure, [0, 3], 3));
assert(_check_location_populated_quadrant(structure, [0, 3], 4));
assert(_check_location_populated_quadrant(structure, [0, 3], 5));

assert(_check_location_populated_quadrant(structure, [1, 3], 0));
assert(_check_location_populated_quadrant(structure, [1, 3], 1));
assert(_check_location_populated_quadrant(structure, [1, 3], 2));
assert(_check_location_populated_quadrant(structure, [1, 3], 3));
assert(_check_location_populated_quadrant(structure, [1, 3], 4));
assert(!_check_location_populated_quadrant(structure, [1, 3], 5));

assert(_check_location_populated_quadrant(structure, [2, 3], 0));
assert(_check_location_populated_quadrant(structure, [2, 3], 1));
assert(_check_location_populated_quadrant(structure, [2, 3], 2));
assert(!_check_location_populated_quadrant(structure, [2, 3], 3));
assert(_check_location_populated_quadrant(structure, [2, 3], 4));
assert(_check_location_populated_quadrant(structure, [2, 3], 5));

assert(!_check_location_populated_quadrant(structure, [3, 3], 0));
assert(_check_location_populated_quadrant(structure, [3, 3], 1));
assert(_check_location_populated_quadrant(structure, [3, 3], 2));
assert(_check_location_populated_quadrant(structure, [3, 3], 3));
assert(_check_location_populated_quadrant(structure, [3, 3], 4));
assert(!_check_location_populated_quadrant(structure, [3, 3], 5));


tolerance = 0;
decoration = false;
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