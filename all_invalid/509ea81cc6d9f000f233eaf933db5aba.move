
//# publish
module 0xDEAD::TestFeatures {
    use std::signer;
    use std::vector;
    
    // Module to test variable assignments, scope, shadowing, and private functions
    internal fun internal_helper(x: u64): u64 {
        x + 1
    }
    
    // Public function to perform variable assignment and update outside and inside loops
    public fun var_assignment_test() {
        let x = 0u64;

        // Assign outside loop
        let outside_assign = x;

        // Outer loop and variable shadowing
        let x = outside_assign;

        while (x < 5) {
            let inner_x = x; // Shadowed inner variable
            let _ : u64 = inner_x; // Use inner_x
            x = x + 1; // Update outer x
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
        // Variable in nested block
        {
            let y = x + 5;
            // Shadowing variable inside nested block
            let y = y * 2;
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


// Featurres:
// b70ccb6e356eebb5b3735f5f76cd5273: Write script entry points in Move modules
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
// 8171a7fbf944cb0c44bd028f983d3a3b: Handle variable bindings in lambda expressions and blocks to determine their mutability status.
// 41f8c7258935ea12ed715b21888bd747: Assign an expression to a named variable using a 'let' binding in Move.
