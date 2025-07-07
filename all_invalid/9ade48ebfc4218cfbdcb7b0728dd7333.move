
//# publish
module 0xDEAD::TestFeatures {
    use std::signer;
    use std::vector;

    // Move does not support 'internal' functions, use 'private' instead
    // Changed 'internal' to 'private' to fix compilation error
    fun internal_helper(x: u64): u64 {
        x + 1
    }

    // Public function to perform variable assignment and update outside and inside loops
    public fun var_assignment_test() {
        let x = 0u64;

        // Assign outside loop
        let outside_assign = x;

        // Outer scope variable shadowing
        let x = outside_assign;

        // Loop to test variable shadowing and scope
        while (x < 5) {
            let inner_x = x; // Shadowed inner variable
            let _ : u64 = inner_x; // Use inner_x
            // Update outer variable x
            x = x + 1;
        };

        // Shadowing variable in nested block
        let x = 100u64;
        let _ = x; // Use shadowed x
        // Use internal helper
        let _ = internal_helper(x);
    }

    // Public function to test variable bindings in nested blocks and lambdas
    public fun nested_block_and_lambda() {
        let x = 10u64;
        // Nested block with variable shadowing
        {
            let y = x + 5;
            let y = y * 2; // Shadow y inside nested block
            let _ = y;
        }

        // Lambda capturing variable and assigning inside
        let lambda = |a: u64| -> u64 {
            let c = a + 3;
            c
        };
        let result = lambda(x);
        let _ = result;
    }

    // Public function to test private functions cannot be called externally
    public fun test_private_function(): u64 {
        let res = private_helper();
        res
    }

    // Private functions should be marked as 'fun' but not 'public'
    fun private_helper(): u64 {
        42u64
    }

    // Function with nested blocks to test variable scope
    public fun nested_scopes() {
        let a = 1u64;
        {
            let a = 2u64; // Shadow outer a
            let b = a + 1;
            let _ = b;
        }
        // After nested block, a should still be 1
        let c = a + 2;
        let _ = c;
    }
}

// Entry script to invoke various module functions, ensuring correct execution


//# run 0xDEAD::TestFeatures::var_assignment_test


//# run 0xDEAD::TestFeatures::nested_block_and_lambda


//# run 0xDEAD::TestFeatures::test_private_function


//# run 0xDEAD::TestFeatures::nested_scopes
