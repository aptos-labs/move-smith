
//# publish
module 0xDEAD::FeatureInteractionTest {
    use std::debug;
    use std::vector;

    // Define a simple struct for testing
    struct Data has copy, drop, store {
        value: u64,
        label: vector<u8>,
    }

    // Entry point to test variable shadowing and loops
    public fun test_variable_shadowing_and_loops() {
        let outer_var = 0u64;
        // Shadow the variable inside a block
        let outer_var = {
            let inner_var = 10u64; // make inner_var mutable
            while (inner_var > 0) {
                debug::print(&b"Inner loop debug"[..]);
                inner_var = inner_var - 1;
            };
            inner_var
        };
        // outer_var should be 0 here
        let _ = outer_var;
    }

    // Function to allocate and manipulate local variables
    public fun manipulate_locals() {
        let a = 5u64;
        let b = 10u64;
        // Inside a scope, shadow 'a' and 'b'
        let (a, b) = {
            let a = a + 1; // a = 6
            let b = b + 2; // b = 12
            (a, b)
        };
        // outside, original a and b remain unchanged
        let _ = a;
        let _ = b;
    }

    // Test calling an internal function (should be accessible only within module)
    fun internal_add(x: u64, y: u64): u64 {
        x + y
    }

    // Wrapper function to test internal visibility (should be accessible externally)
    public fun call_internal_add(x: u64, y: u64): u64 {
        internal_add(x, y)
    }

    // Static check: ensure that spec annotations (conceptual in comments) are correct
    // (simulate static check - in real Move static analysis would verify purity etc.)
    // Here we just define some snippet that would be analyzed
    // spec]
    fun spec_pure_function(x: u64): u64 {
        // The spec functions should be pure (no violations)
        x + 1
    }

    // Function with conditional logic to test proper evaluation
    public fun conditional_test(flag: bool): u8 {
        if (flag) {
            42u8
        } else {
            24u8
        }
    }

    // Function to simulate a lambda with currying
    public fun curried_lambda(a: u8): |u8|u8 {
        |b: u8| {
            a + b
        }
    }

    // Function to test conditional based on lambda output
    public fun evaluate_with_lambda(flag: bool): u8 {
        let lambda = curried_lambda(10);
        let result = if (flag) {
            lambda(5)
        } else {
            lambda(15)
        };
        result
    }

    // Debugging utility: convert AST node to string (simulated via debug print)
    public fun debug_print_ast_node(node: vector<u8>) {
        debug::print(&node);
    }

    // Function to simulate AST node string representation
    public fun test_ast_serialization() {
        let node1 = b"Let x = 5"; // Simulate an AST node string
        let node2 = b"If condition then"; // Another AST node string
        debug_print_ast_node(node1);
        debug_print_ast_node(node2);
    }

    // Lambda lifting simulation: transform nested lambda to top-level functions
    // (Actually just define a top-level function and call it to simulate lifting)
    public fun lifted_add(x: u64, y: u64): u64 {
        x + y
    }

    public fun test_lambda_lifting() {
        let a = 20u64;
        let b = 22u64;
        let sum = lifted_add(a, b);
        // Use debug to print value
        debug::print(&b"Sum printed"[..]);
        let _ = sum;
    }
}


//# run 0xDEAD::FeatureInteractionTest::test_variable_shadowing_and_loops



//# run 0xDEAD::FeatureInteractionTest::manipulate_locals



//# run 0xDEAD::FeatureInteractionTest::call_internal_add --args 3u64 4u64



//# run 0xDEAD::FeatureInteractionTest::conditional_test --args true



//# run 0xDEAD::FeatureInteractionTest::evaluate_with_lambda --args false



//# run 0xDEAD::FeatureInteractionTest::test_ast_serialization



//# run 0xDEAD::FeatureInteractionTest::test_lambda_lifting


// Features:
// b70ccb6e356eebb5b3735f5f76cd5273: Write script entry points in Move modules
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
// fdc6779e3d725d21cb1af960a124c0e2: Implement specification checking to ensure that specifications adhere to pureness and correctness standards.
// 7f343e5b6a46a90c5e940d2d1b876be9: Test that function currying with different closures correctly evaluates conditional logic and produces expected results.
// 21ac1e75f2dd47f51c2bfced1ce8d74d: Convert AST nodes to a string representation for debugging purposes.
// 68befe7d06917c06f26484815e5de88d: Execute lambda lifting transformations.
