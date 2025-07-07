
//# publish
module 0xCAFE::MathModule {
    // Simple addition function returning the sum of two u8 numbers plus 1
    public fun add_and_increment(a: u8, b: u8): u8 {
        let sum = a + b;
        let result = sum + 1;
        result
    }

    // Function with a lambda that multiplies two u8 numbers and adds 10u8
    public fun compute_with_lambda(x: u8, y: u8): u8 {
        let lambda: |u8, u8| u8 = |a: u8, b: u8| {
            a * b + 10u8
        };
        lambda(x, y)
    }

    // Inline function returning a tuple with two u8 values incremented by 5 and 10 respectively
    public inline fun inline_tuple(x: u8): (u8, u8) {
        (x + 5u8, x + 10u8)
    }
}


//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::MathModule;

    // Calls the add_and_increment function from MathModule
    public fun call_add_and_increment(a: u8, b: u8): u8 {
        MathModule::add_and_increment(a, b)
    }

    // Calls compute_with_lambda from MathModule
    public fun call_compute_with_lambda(a: u8, b: u8): u8 {
        MathModule::compute_with_lambda(a, b)
    }

    // Calls inline_tuple from MathModule and sums the tuple values
    public fun call_inline_tuple_sum(x: u8): u8 {
        let (v1, v2) = MathModule::inline_tuple(x);
        v1 + v2
    }
}


//# run 0xCAFE::MathModule::add_and_increment --args 10u8 20u8


//# run 0xCAFE::MathModule::compute_with_lambda --args 3u8 4u8


//# run 0xCAFE::CallerModule::call_add_and_increment --args 7u8 8u8


//# run 0xCAFE::CallerModule::call_compute_with_lambda --args 5u8 6u8


//# run 0xCAFE::CallerModule::call_inline_tuple_sum --args 10u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
