
//# publish
module 0xCAFE::AdderModule {
    public fun add_two_values(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return a fixed value + sum to check calculation + return
        42 + sum
    }

    public fun with_lambda(x: u8, y: u8): u8 {
        let add = |a: u8, b: u8| a + b;
        let result = add(x, y);
        // Use lambda result plus a constant to test lambda usage and return
        result + 10u8
    }

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }
}


//# run 0xCAFE::AdderModule::add_two_values --args 1u8 2u8


//# run 0xCAFE::AdderModule::with_lambda --args 5u8 7u8


//# publish
module 0xCAFE::NestedCalls {
    use 0xCAFE::AdderModule;

    public fun call_inline_and_add(a: u8, b: u8, c: u8): u8 {
        let part1 = AdderModule::inline_add(a, b);
        // Add c to the result from inline_add and return
        part1 + c
    }

    public fun runner() {
        let _ = call_inline_and_add(3u8, 4u8, 5u8);
    }
}


//# run 0xCAFE::NestedCalls::call_inline_and_add --args 3u8 4u8 5u8


//# run 0xCAFE::NestedCalls::runner


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
