
//# publish
module 0xCAFE::LabelAndPatternTest {
    use std::vector;

    struct Point has copy, drop, store {
        x: u8,
        y: u8,
    }

    struct Container has store {
        points: vector<Point>,
    }

    public fun test_labels_and_pattern_binding() {
        let point = Point {x: 10, y: 20};

        // Binding pattern with type annotation
        let p: Point = point;

        // Using a label before expression
        'start: {
            let x_coord = p.x;
            let y_coord = p.y;
            // will break out of label immediately
            break 'start;
        };

        // Bind the result of a tuple expression to a pattern with type
        let (a, b): (u8, u8) = (1, 2);

        // Create a vector of points to test wildcard in access (not real wildcard usage, just an example)
        let container = Container {
            points: vector[
                Point {x: 1, y: 1},
                Point {x: 2, y: 2},
                Point {x: 3, y: 3},
            ],
        };

        // Using 'let' pattern matching on vector element
        let first_point = *vector::borrow(&container.points, 0);
        let Point { x: first_x, y: first_y } = first_point;

        // Using a label to loop and break
        let counter = 0;
        'countup: while (counter < 3) {
            counter = counter + 1;
            if (counter == 3) {
                break 'countup;
            };
        };

        // Nested pattern match with binding
        match (p) {
            Point { x: xx, y: 20 } => {
                // xx bound to p.x when p.y == 20
                let _ = xx;
            },
            _ => {}
        };
    }
}


//# run 0xCAFE::LabelAndPatternTest::test_labels_and_pattern_binding


// Featurres:
// 726a6e010111e3aaf65c42aaa1e84ebe: Define labels using a single quote followed by a name (e.g., 'label).
// 1aa8028077f33b2955e8407c5e0c47f4: Use the 'wildcard' symbol '*' to specify unspecified or any subcomponent in a name access, if allowances are configured.
// 1eb3a6ffbc69a8c241e0efa818707998: Bind the result of an expression to a pattern using 'let', with optional type annotation.
