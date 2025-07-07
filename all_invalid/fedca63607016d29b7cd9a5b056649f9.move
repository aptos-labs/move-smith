//# publish
module 0xCAFE::TestAssignmentAndSpec {
    use std::vector;

    // A struct to test assignment with destructuring
    struct Point has store, copy, drop {
        x: u64,
        y: u64,
    }

    // A struct for nested pattern assignments
    struct Nested has store, copy, drop {
        p1: Point,
        p2: Point,
    }

    // Test function to assign to single lvalue with patterns
    public fun test_assignment() {
        // Simple assignment to variable
        let a = 10u64;
        let a = 20u64;

        // Assignment via destructuring tuple
        let (x, y) = (1u64, 2u64);
        let (x, y) = (3u64, 4u64);

        // Assignment via destructuring Point struct
        let point = Point { x: 0u64, y: 0u64 };
        // Here, assignment with destructuring to the struct's fields:
        let Point { x: px, y: py } = point;
        // Recombine after updating
        let point = Point { x: px + 1, y: py + 2 };

        // Assignment nested destructuring with structs
        let nested = Nested { p1: Point { x: 0, y: 0 }, p2: Point { x: 0, y: 0 } };
        let Nested { p1, p2 } = nested;
        let nested = Nested { p1: Point { x: p1.x + 5, y: p1.y + 5 }, p2: Point { x: p2.x + 10, y: p2.y + 10 } };

        // Simple single lvalue assignments after destructuring
        let b = 0u8;
        let b = 100u8;
    }

    // A "runner" function to invoke test_assignment
    public fun run() {
        test_assignment();
    }

    // Specification block: spec functions, invariants, and messages

    spec module {
        // A spec struct mirroring Point for specifications
        struct SpecPoint {
            x: u64,
            y: u64,
        }

        // Spec function to check equality of SpecPoint fields
        fun point_equals(p: SpecPoint, x: u64, y: u64): bool {
            p.x == x && p.y == y
        }

        invariant [diagnostic = "Invariant failed: x and y must be equal", start_line = 37, start_column = 5, end_line = 37, end_column = 41]
        forall p in vector<SpecPoint> {
            // invariant that asserts x == y for testing diagnostic ranges
            p.x == p.y
        }
    }
}
//# run 0xCAFE::TestAssignmentAndSpec::run

//# publish
module 0xCAFE::DiagnosticSpecMessages {
    // Just a dummy struct for the tests
    struct Dummy has store, drop, copy {
        val: u8,
    }

    // Function to show a spec function returns boolean
    public fun is_zero(x: u8): bool {
        x == 0
    }

    // Runner function, no args, no return
    public fun run() {
        let d = Dummy { val: 0 };
        let flag = is_zero(d.val);
        // no asserts as requested
        let _ = flag;
    }

    spec module {
        // Spec function with diagnostic message and source range
        fun always_true(): bool {
            true
        }

        invariant [diagnostic = "This invariant always holds", start_line = 21, start_column = 9, end_line = 21, end_column = 48]
        always_true()
    }
}
//# run 0xCAFE::DiagnosticSpecMessages::run