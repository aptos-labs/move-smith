// # Move compiler debug environment variable example, no Move code needed here. 
// This is just a comment to indicate the environment variable can be set:
// export MOVE_COMPILER_DEBUG=1 
// or export MVC_DEBUG=1


//# publish
module 0xCAFE::Ops {
    // Module to test operations like addition and boolean logic
    
    public fun add_two(a: u8, b: u8): u8 {
        // Returns a + b + 1u8 to test addition and return values
        let sum = a + b;
        sum + 1u8
    }

    public fun add_with_lambda(x: u8, y: u8): u8 {
        // Lambda returns x + y (captures x and y via parameters)
        let adder: |u8, u8| u8 = |a, b| {
            a + b
        };
        let result = adder(x, y);
        // Return result + 2
        result + 2u8
    }
    
    // Inline function to be called from other modules to test nested calls
    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }
    
    const CONST_BOOL: bool = true && (false || !false);
    const CONST_AND: bool = true && false;
    const CONST_OR: bool = false || true;
    const CONST_NOT: bool = !true;
}


//# run 0xCAFE::Ops::add_two --args 5u8 7u8


//# run 0xCAFE::Ops::add_with_lambda --args 3u8 4u8


//# publish
module 0xCAFE::NestedCaller {
    use 0xCAFE::Ops;

    public fun call_inline_add(a: u8, b: u8): u8 {
        let c = Ops::inline_add(a, b);
        c + 1u8
    }
}


//# run 0xCAFE::NestedCaller::call_inline_add --args 10u8 20u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 33a0e94ea63008c770c66e673cd53379: Enable debugging mode for the Move compiler by setting the 'MOVE_COMPILER_DEBUG' or 'MVC_DEBUG' environment variable.
// 55313936edb6b3b1f6d3a596b931e255: Test that boolean operators (&&, ||, !) and combinations thereof are correctly evaluated and can be used in constant expressions.
