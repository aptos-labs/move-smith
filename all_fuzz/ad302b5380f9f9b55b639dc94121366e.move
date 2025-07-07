
//# publish
module 0xCAFE::AddTest {
    public inline fun add_two(a: u8, b: u8): u8 {
        a + b
    }

    public fun compute_and_return_sum(a: u8, b: u8): u8 {
        let sum = add_two(a, b);
        if (sum > 10) {
            100u8
        } else {
            50u8
        }
    }

    public fun test_lambda(a: u8, b: u8): u8 {
        let lambda: |u8, u8|u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        lambda(a, b)
    }

    public inline fun inline_inner(x: u8): u8 {
        x * 2
    }

    public fun inline_outer(x: u8): u8 {
        let doubled = inline_inner(x);
        doubled + 1
    }

    public fun complex_control_flow(u: u8): u8 {
        let count = 0u8;
        if (u > 5) {
            count = u;
        } else {
            count = 1u8;
        };

        while (count < 10) {
            count = count + 1;
        };

        loop {
            if (count == 15) {
                break;
            };
            count = count + 1;
        };
        count
    }
}


//# run 0xCAFE::AddTest::compute_and_return_sum --args 4u8 7u8


//# run 0xCAFE::AddTest::compute_and_return_sum --args 2u8 3u8


//# run 0xCAFE::AddTest::test_lambda --args 3u8 6u8


//# run 0xCAFE::AddTest::inline_outer --args 4u8


//# run 0xCAFE::AddTest::complex_control_flow --args 3u8



//# publish
module 0xCAFE::CallInline {
    use 0xCAFE::AddTest;

    public fun call_inline_functions(x: u8, y: u8): u8 {
        let inner_result = AddTest::inline_inner(x);
        let outer_result = AddTest::inline_outer(y);
        inner_result + outer_result
    }
}


//# run 0xCAFE::CallInline::call_inline_functions --args 3u8 4u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 9a4f6586c3a8471e51b539c30c0736b8: Ensure inline functions are called in bottom-up order so that inline functions are processed before the functions that call them.
// a853f5fb5a697c8d86582f6705936d1f: Write control flow expressions such as 'if', 'while', and 'loop' statements within expressions.
