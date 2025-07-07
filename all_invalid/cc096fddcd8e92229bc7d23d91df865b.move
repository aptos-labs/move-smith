//# publish
module 0xCAFE::SpecModules {
    use std::signer;

    struct Point has copy, drop, store {
        x: u64,
        y: u64,
    }

    /// Spec block with members for the Point struct
    spec Point {
        invariant x >= 0;
        predicate valid_point(p: Point) { p.x + p.y < 100 }
    }

    spec module {
        /// Module level constant spec member
        const MAX_SUM: u64 = 100;

        /// Spec function for add_points function
        spec fun add_points(a: Point, b: Point): Point;

        /// Spec function for update_point mut ref test
        spec fun update_point(p: &mut Point);
    }

    public inline fun add_points(a: Point, b: Point): Point {
        Point {x: a.x + b.x, y: a.y + b.y}
    }

    // A function to update a Point in place
    public fun update_point(p: &mut Point) {
        p.x = p.x + 1;
        p.y = p.y + 1;
    }

    // A function testing inline function with mutable reference usage multiple times
    public fun inline_update_twice() {
        let mut p = Point { x: 1, y: 2 };

        // Inline function mutates p twice within a single expression 
        f(p_mut_ref: &mut Point): u64 {
            update_point(p_mut_ref);
            update_point(p_mut_ref);
            p_mut_ref.x + p_mut_ref.y
        };
        let res = f(&mut p);
        let _ = res; // consume variable to avoid warnings
    }
}

//# run 0xCAFE::SpecModules::add_points

//# run 0xCAFE::SpecModules::update_point

//# run 0xCAFE::SpecModules::inline_update_twice

// Featurres:
// 2ee7e9c6ec65f7f18bd99ccef989791c: Declare members (such as properties, asserts, or invariants) inside spec blocks to define behaviors and checks for Move code elements.
// b55ad2e03b67074aa23a762dfdf31657: Rewrite specifications for Move modules and functions to improve or transform them
// 37a1bfd1a456704dfea42fde00aaefbd: Test that inline functions correctly update and use mutable references when the same variable is passed multiple times within a single expression.
