
//# publish
module 0xCAFE::LambdaAndInline {
    /// A simple function that returns the sum of two u8 numbers added to 10
    public fun add_and_offset(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 10
    }

    /// A function containing a lambda that doubles the input, and applies it twice
    public fun double_twice(x: u8): u8 {
        let doubler: |u8| u8 has copy+drop = |v: u8| {
            v * 2
        };
        let once = doubler(x);
        doubler(once)
    }

    /// A runner that uses the above lambda and add_and_offset
    public fun runner(): u8 {
        let val = double_twice(3u8);
        add_and_offset(val, 2u8)
    }
}


//# publish
module 0xCAFE::InlineCaller {
    use 0xCAFE::LambdaAndInline;

    /// Calls LambdaAndInline::add_and_offset and returns the result
    public fun call_add_and_offset(a: u8, b: u8): u8 {
        LambdaAndInline::add_and_offset(a, b)
    }

    /// Calls LambdaAndInline::runner and returns the value
    public fun call_runner(): u8 {
        LambdaAndInline::runner()
    }
}


//# run 0xCAFE::LambdaAndInline::add_and_offset --args 7u8 8u8


//# run 0xCAFE::LambdaAndInline::double_twice --args 4u8


//# run 0xCAFE::LambdaAndInline::runner


//# run 0xCAFE::InlineCaller::call_add_and_offset --args 5u8 6u8


//# run 0xCAFE::InlineCaller::call_runner


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
