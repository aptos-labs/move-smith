
//# publish
module 0xCAFE::InlineAndAssignTest {
    use std::vector;

    struct Point has copy, drop, store {
        x: u8,
        y: u8,
    }

    struct Container has copy, drop, store {
        p: Point,
        val: u64,
    }

    enum State has copy, drop {
        Empty,
        Filled(Point),
        Wrapped { c: Container }
    }

    // Inline function that returns a tuple
    public inline fun inline_increment(x: u8): (u8, u8) {
        (x + 1, x + 2)
    }

    // Function to test various assignments and mutations
    public fun assignment_tests() {
        // Direct assignments to struct fields
        let pt = Point {x: 1, y: 2};
        pt.x = 3;
        pt.y = 4;

        // Assignments via reference
        let pt_ref: &mut Point = &mut pt;
        pt_ref.x = 5;
        pt_ref.y = 6;

        // Chained field assignments by reassigning struct
        pt = Point {x: pt_ref.x + 1, y: pt_ref.y + 1};

        // Using enum with tuple variant
        let st: State = State::Filled(pt);
        match st {
            State::Empty => (),
            State::Filled(mut p) => {
                p.x = p.x + 1;
                p.y = p.y + 1;
                st = State::Filled(p);
            },
            State::Wrapped { c: _ } => (),
        };

        // Using enum with struct variant and chained assignment inside
        let cont = Container {p: pt, val: 10};
        st = State::Wrapped { c: cont };
        match st {
            State::Wrapped { mut c } => {
                // Chained mut fields
                c.p.x = c.p.x + 2;
                c.p.y = c.p.y + 2;
                c.val = c.val + 10;
                st = State::Wrapped { c };
            },
            _ => (),
        };

        // Assignment inside a while loop
        let x = 0;
        let pt2 = Point {x: 0, y: 0};
        while (x < 3) {
            pt2.x = pt2.x + 1;
            pt2.y = pt2.y + 2;
            x = x + 1;
        };

        // Assignment using inline function returning tuple
        let (a, b) = inline_increment(pt2.x);
        pt2.x = a;
        pt2.y = b;
    }

    // Package visible function (accessible only inside this package)
    package fun package_function(x: u8): u8 {
        x * 2
    }

    public fun run_package_test(): u8 {
        // Calling package function inside the package is allowed
        package_function(5u8)
    }
}


//# run 0xCAFE::InlineAndAssignTest::assignment_tests


//# run 0xCAFE::InlineAndAssignTest::run_package_test
