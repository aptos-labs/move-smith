
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

        let inner = outer_lambda(2u8);
        let result1 = inner(3u8);
        
        // Deeply nested lambda chain with byte serialization
        let deep_lambda: |vector<u8>| u8 = |bytes: vector<u8>| {
            // Deserialize bytes into a u8 (simulate serialization)
            // In actual Move, this might involve some byte operations, but here simulate with length
            let len = vector::length(&bytes);
            len as u8
        };

        let bytes = b"abcdef"; // Byte string
        let result2 = deep_lambda(bytes);
        
        // Call previous lambdas via Call expression
        let sum = call_func_with_move(simple_add, 4u8, 5u8);
        
        // Use ExpCall expression: calling nested lambda with move
        let nested_result = (outer_lambda)(10u8);
        let deep_result = (deep_lambda)(vector::empty<u8>());
    }
}


//# run 0xCAFE::NestedFunctionTest::nested_lambda_call


// Featurres:
// 5cb59050f7881a0c0d66dad8d4470a0c: Move a variable using the move keyword.
// 4b2614c9bb3829530ed34b3fe278aa0e: Call functions, including lambda or function pointer calls, with `Call` and `ExpCall` expressions.
// eb37c7fb381e8cf238c7510307164345: Test that deep nested lambdas, byte serialization, and higher-order function passing work correctly together in Move.
