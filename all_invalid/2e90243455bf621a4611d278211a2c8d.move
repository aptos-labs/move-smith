//# publish
module 0xCAFE::AccessAndStructTest {
    use std::vector;

    struct Point has copy, drop, store {
        x: u64,
        y: u64,
    }

    struct Container has store {
        points: vector<Point>,
    }

    public fun create_container(): Container {
        let p1 = Point { x: 10, y: 20 };
        let p2 = Point { x: 30, y: 40 };
        let pts = vector::empty<Point>();
        vector::push_back(&mut pts, p1);
        vector::push_back(&mut pts, p2);
        Container { points: pts }
    }

    public fun access_fields_and_index(c: &Container): u64 {
        // Access dotted fields and index in vector
        let first_point = *vector::borrow(&c.points, 0);
        let second_point = *vector::borrow(&c.points, 1);

        // Access named fields using dotted expressions
        let sum_x = first_point.x + second_point.x;
        let sum_y = first_point.y + second_point.y;

        sum_x + sum_y
    }

    public fun run_example(): u64 {
        let container = create_container();
        access_fields_and_index(&container)
    }
}

// Spec block to test 'use' declarations in specs
spec 0xCAFE::AccessAndStructTest {
    use std::vector;
    use 0xCAFE::AccessAndStructTest;

    invariant container_points_nonempty(c: &AccessAndStructTest::Container) {
        vector::length(&c.points) > 0
    }
}

//# run 0xCAFE::AccessAndStructTest::run_example

// Featurres:
// 6a39ccb0349058f05657fa531445d8b6: Access dotted or indexed data with `ExpDotted` and `Index` expressions.
// 227ad258a66ad82ed33365ca2fc3d83a: Define structs with named fields in Move modules
// 17c390b072c12b3bceb96eba26f1ecae: Include 'use' declarations at the start of a spec block to import other named specifications.
