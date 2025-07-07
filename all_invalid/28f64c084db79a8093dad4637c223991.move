
//# publish
module 0xDEAD::TestModule {
    // Using standard library components
    use std::debug;

    // Internal function: restricted access
    fun internal_add(x: u16, y: u16): u16 {
        x + y
    }

    // Public function that internally calls the private add
    public fun exposed_add(x: u16, y: u16): u16 {
        internal_add(x, y)
    }
}


//# run 0xDEAD::TestModule::exposed_add --args 10u16 20u16


//# publish
module 0xBADD::ShadowTest {
    // This module tests variable shadowing, variable scope,
    // destructuring, mutable references, and pattern matching.

    use std::debug;

    // Struct to test destructuring and pattern matching
    struct Point has copy, drop {
        x: u64,
        y: u64,
    }

    // Internal function to create a point
    fun make_point(x: u64, y: u64): Point {
        Point { x, y }
    }

    // Internal function to update a point
    fun update_point(p: &mut Point, new_x: u64, new_y: u64) {
        p.x = new_x;
        p.y = new_y;
    }

    // Public function to perform complex variable shadowing, destructuring
    // and mutable reference operations.
    public fun complex_shadowing_test() {
        // Outer scope variable
        let outer_var = 100u64;

        // Shadowed variable inside a block
        {
            let outer_var = 200u64;
            debug::print(&b"Shadowed outer_var:\n"[..]);
            debug::print_u64(outer_var);
            // Nested block shadowing
            {
                let outer_var = 300u64;
                debug::print(&b"Nested shadow outer_var:\n"[..]);
                debug::print_u64(outer_var);
            }
            // Back to first shadowing level
            debug::print(&b"Back to first shadow outer_var:\n"[..]);
            debug::print_u64(outer_var);
        }

        // Confirm outer_var outside blocks remains unchanged
        debug::print(&b"Original outer_var:\n"[..]);
        debug::print_u64(outer_var);

        // Destructuring assignment
        let point = make_point(1, 2);
        let Point { x: px, y: py } = point;
        debug::print(&b"Destructured point:\n"[..]);
        debug::print_u64(px);
        debug::print_u64(py);

        // Mutable reference to Point
        let point2 = make_point(10, 20);
        {
            // Mutable borrow
            let point_ref: &mut Point = &mut point2;
            // Update via mutable reference
            update_point(point_ref, 100, 200);
            debug::print(&b"Updated point2 via mutable reference:\n"[..]);
            debug::print_u64(point2.x);
            debug::print_u64(point2.y);
        }
        // Verify that point2 has updated values
        debug::print(&b"Final point2:\n"[..]);
        debug::print_u64(point2.x);
        debug::print_u64(point2.y);

        // Pattern matching on an enum
        enum Response has copy, drop {
            Success,
            Error(u8),
            Progress { current: u64, total: u64 },
        }

        let res = match (Response::Progress { current: 5, total: 10 }) {
            Response::Success => {
                debug::print(&b"Success\n"[..]);
            },
            Response::Error(code) => {
                debug::print(&b"Error code:\n"[..]);
                debug::print_u8(code);
            },
            Response::Progress { current, total } => {
                debug::print(&b"Progress: "\[..]);
                debug::print_u64(current);
                debug::print(&b"/"\[..]);
                debug::print_u64(total);
            }
        };
        // No explicit return here, but function ends with last expression
    }

    // Function that calls other internal functions and tests scope
    public fun test_internal_access() {
        // Valid: calling internal function within same module
        let sum = internal_add(3u16, 4u16);
        // Also calling public function
        let res = exposed_add(5u16, 6u16);
        debug::print_u16(sum);
        debug::print_u16(res);
    }

    // Function to test variable shadowing in loops and scope
    public fun loop_and_shadow() {
        let x = 0u64;
        let x = x; // Make mutable local copy to test Shadowing
        let y = 10u64;
        let y = y;

        let i = 0u64;
        while (i < y) {
            let x = x + i; // Shadow outer x
            i = i + 1;
        };
        // After loop, outer x should be unchanged
        debug::print(&b"Outer x after loop:\n"[..]);
        debug::print_u64(x); // Should be 0

        // Verify that inner x shadowing does not affect outer x
        debug::print(&b"Loop variable i:\n"[..]);
        debug::print_u64(i); // Should be 10
    }
}


//# run 0xBADD::ShadowTest::complex_shadowing_test


//# run 0xBADD::ShadowTest::test_internal_access


//# run 0xBADD::ShadowTest::loop_and_shadow


// Featurres:
// 5941dd503b9dcc73e363012d080654d1: Treat the entire program as a target for comprehensive analysis.
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
// e9cdcefcd1f70fddde31fbaee0a020c1: Test destructuring assignment and mutable reference updates during struct construction and pattern matching.
