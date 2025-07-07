
//# publish
module 0xFACE::ComprehensiveTest {
    // Use std to access core functionalities
    use std::vector;
    use std::signer;

    // Internal resource with internal visibility to test access restrictions
    struct InternalResource {
        value: u64,
    }

    // Only accessible within this module
    public fun create_internal_resource(s: &signer): InternalResource {
        InternalResource { value: 42 }
    }

    // Internal function with internal visibility
    fun internal_helper(x: u64): u64 {
        x + 10
    }

    // Public function calling internal helper (via inline call)
    public fun call_internal_helper(x: u64): u64 {
        internal_helper(x)
    }

    // Function attempting to access internal resource outside module (should not compile)
    // This is a test; in actual test environment, trying access outside should fail.
    // Here, just declare the function to see internal access restrictions.
    public fun try_access_internal(s: &signer): u64 {
        // move_from<InternalResource>(signer::address_of(s)); // Should fail if uncommented
        0
    }
}

// Script to instantiate variables, shadow variables in loops, and test various features


//# run
script {
    // Declare variables with shadowing in nested loops and while
    let x_outer: u64 = 5;
    let y: u64 = x_outer;
    let i: u64 = 0;

    // While loop with variable shadowing
    while (i < 3) {
        let x: u64 = i + 10; // Shadow outer x
        // Use mutable variable for y if it's intended to be mutated
        // For safety, declare y as mutable
        // But since y is immutable, create a mutable copy
        // Alternatively, declare y as mutable outside
        // So to update y, declare mutable outside the loop as needed
        // For now, reassign y as mutable:
        // But y is immutable, so simulate accumulation via a mutable variable
        // Since the user code just does y = y + x, make y mutable here
        // So declare y as mutable outside, or as a mutable copy of y
        // Let's declare y as mutable outside

        // Let's fix this to compile correctly
    }

    // Corrected variable: declare y as mutable
    // redo the code accordingly

}

// Rewritten with proper variable declarations and mutable variables


//# run
script {
    // Declare variables with shadowing in nested loops and while
    let x_outer: u64 = 5;
    let y: u64 = x_outer; // make y mutable for accumulation
    let i: u64 = 0;

    // While loop with variable shadowing
    while (i < 3) {
        let x: u64 = i + 10; // Shadow outer x
        y = y + x; // Accumulate shadowed x
        i = i + 1;
    };

    // Call module function that invokes internal
    let result: u64 = 0xFACE::ComprehensiveTest::call_internal_helper(50);
    // result should be 60 (50 + 10)

    // Access internal resource and test restricted access (commented out, should fail)
    // let _ = 0xFACE::ComprehensiveTest::try_access_internal(&signer::borrow(&signer::new_account())); // Uncomment to test restriction

    // Create vector and test sequences
    let vec: vector<u8> = vector::empty();
    vector::push_back(&vec, 1);
    vector::push_back(&vec, 2);
    vector::push_back(&vec, 3);

    let element_0 = *vector::borrow(&vec, 0);
    let element_1 = *vector::borrow(&vec, 1);

    // Sequence expression with single expression
    let sum: u8 = (element_0 + element_1);
}

// Additional script to instantiate and verify move functions with mutable references and sequences


//# run
script {
    // Call function with the helper
    let result1: u64 = 0xFACE::ComprehensiveTest::call_internal_helper(100);
    // Do not call mutable functions directly outside; ensure code compliance

    // Test sequence with multiple expressions
    let sequence_result: u8 = (
        {
            let a: u8 = 10;
            let b: u8 = 20;
            a + b
        },
        {
            let c: u8 = 30;
            c * 2
        }
    ).1; // The sequence returns a tuple, so need to index or handle differently

    // But in Move, sequence expressions return last expression, or tuples with parentheses
    // Let's rewrite to get second value

    // Proper sequence of expressions: in Move, parentheses create a tuple
    let sequence_value: u8 = (
        {
            let a: u8 = 10;
            let b: u8 = 20;
            a + b
        },
        {
            let c: u8 = 30;
            c * 2
        }
    ).1;

    // Verify shadowing and scope
    let outer_var: u64 = 0;
    let sequence_value2: u64 = if (outer_var == 0) {
        let outer_var: u64 = 100; // Shadow outer
        outer_var + 1
    } else {
        0
    };
    // The sequence_value2 should be 101 when outer_var == 0
}
