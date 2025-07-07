
//# publish
module 0xCAFE::AddAndLambda {
    /// Returns the sum of a and b as u8
    public fun add_u8(a: u8, b: u8): u8 {
        a + b
    }

    /// Calls a lambda that sums two u8 numbers and returns the result plus c
    public fun add_with_lambda(a: u8, b: u8, c: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        let sum = lambda(a, b);
        sum + c
    }

    /// Runner function to test the above two functions
    public fun runner(): u8 {
        let s1 = add_u8(3u8, 4u8);
        let s2 = add_with_lambda(5u8, 6u8, 7u8);
        // return s1 + s2 to test both
        s1 + s2
    }
}


//# run 0xCAFE::AddAndLambda::add_u8 --args 100u8 55u8


//# run 0xCAFE::AddAndLambda::add_with_lambda --args 10u8 20u8 30u8


//# run 0xCAFE::AddAndLambda::runner



//# publish
module 0xCAFE::InlineCall {
    use 0xCAFE::AddAndLambda;

    /// Calls the inline add_u8 function in AddAndLambda module twice and adds results
    public fun nested_calls(a: u8, b: u8, c: u8, d: u8): u8 {
        let sum1 = AddAndLambda::add_u8(a, b);
        let sum2 = AddAndLambda::add_u8(c, d);
        sum1 + sum2
    }

    /// Runner that calls nested_calls with fixed args
    public fun runner(): u8 {
        nested_calls(1u8, 2u8, 3u8, 4u8)
    }
}


//# run 0xCAFE::InlineCall::nested_calls --args 10u8 20u8 30u8 40u8


//# run 0xCAFE::InlineCall::runner


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
