
//# publish
module 0xCAFE::TestFunctions {
    public fun add_u8_and_return_sum(a: u8, b: u8): u8 {
        let sum = a + b;
        sum
    }

    public fun lambda_example(x: u8, y: u8): u8 {
        let add: |u8, u8| u8 has copy+drop = |p: u8, q: u8| {
            p + q
        };
        add(x, y)
    }

    public inline fun inline_sum(a: u8, b: u8): u8 {
        a + b
    }

    public fun call_inline_from_inline(c: u8, d: u8): u8 {
        // inline_sum is inline, so calling it here tests nested inline call
        inline_sum(c, d)
    }

    public fun break_with_label_example(): u8 {
        let count = 0u8;
        'outer_loop: loop {
            count = count + 1;
            if (count == 5) {
                break 'outer_loop;
            };
        };
        count
    }
}


//# publish
module 0xCAFE::UseTestFunctions {
    use 0xCAFE::TestFunctions;

    // Call add_u8_and_return_sum and do a nested call to inline_sum inside call_wrapper
    public fun call_wrapper(a: u8, b: u8): u8 {
        let s = TestFunctions::add_u8_and_return_sum(a, b);
        let inline_result = TestFunctions::call_inline_from_inline(a, b);
        // Return sum of results, but only one returned (to test interface)
        s + inline_result
    }

    // Function that uses lambda from TestFunctions module via lambda_example
    public fun lambda_usage(x: u8, y: u8): u8 {
        TestFunctions::lambda_example(x, y)
    }
}


//# run 0xCAFE::TestFunctions::add_u8_and_return_sum --args 7u8 8u8


//# run 0xCAFE::TestFunctions::lambda_example --args 10u8 20u8


//# run 0xCAFE::TestFunctions::call_inline_from_inline --args 15u8 25u8


//# run 0xCAFE::TestFunctions::break_with_label_example


//# run 0xCAFE::UseTestFunctions::call_wrapper --args 3u8 4u8


//# run 0xCAFE::UseTestFunctions::lambda_usage --args 5u8 6u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// fc8c5aa734cf28687187e2a295319455: Disallow assignment of module access expressions outside of a spec context.
// 1a7a52c3626ed29ee0b31738d0130103: Use 'break' with optional labels.
