//# publish
module 0xCAFE::NestedFunctionTest {
    use std::vector;

    // A simple function to be called
    public fun simple_add(x: u8, y: u8): u8 {
        x + y
    }

    // Higher-order function accepting a function pointer
    public fun call_func_with_move(f: |u8, u8| u8, a: u8, b: u8): u8 {
        f(a, b)
    }

    // Function to create nested lambdas and call them
    public fun nested_lambda_call() {
        // lambda that returns another lambda
        let outer_lambda: |u8| |u8| u8 = |a: u8| {
            |b: u8| {
                // Inside inner lambda, call outer lambda with some value
                let c = a + b;
                c
            }
        };

        // To consume outer_lambda, we need to move it into a new variable
        // Since outer_lambda is used after this point, clone it for multiple uses
        // But in Move, functions (closures) are copyable if they implement Copy,
        // which lambdas do not by default. So, to fix the move issues, we can 
        // reassign outer_lambda to a new variable or take references.

        // Move outer_lambda into inner for reuse, then recreate it to avoid move conflicts
        let outer_lambda_copy = outer_lambda;

        // Use the copy for the inner call
        let inner = outer_lambda_copy(2u8);
        
        // Call the inner lambda
        let result1 = inner(3u8);
        // Note: result1 is unused, but that's okay for now

        // Deeply nested lambda with byte serialization simulation
        let deep_lambda: |vector<u8>| u8 = |bytes: vector<u8>| {
            // Deserialize bytes into a u8 (simulate serialization)
            // In this case, just get length
            let len = vector::length(&bytes);
            len as u8
        };

        // Byte string
        let bytes = b"abcdef";

        // Clone deep_lambda if needed to avoid move issues
        let deep_lambda_clone = deep_lambda;

        let result2 = deep_lambda_clone(bytes);

        // Call previous lambdas via Call expression
        let sum = call_func_with_move(simple_add, 4u8, 5u8);

        // Use ExpCall expression: calling nested lambda with move
        // Since we cannot move outer_lambda again (it's already used), recreate as needed
        let result3 = (outer_lambda)(10u8);
        // For deep_lambda, re-create or clone if necessary
        let deep_lambda_again = deep_lambda;
        let deep_result = (deep_lambda_again)(vector::empty<u8>());
    }
}
