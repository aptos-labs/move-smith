
//# publish
module 0xCAFE::MathTest {
    public fun add_and_return_sum(a: u8, b: u8): u8 {
        let sum = a + b;
        // Always ends with semicolon for `if` as statement
        if (sum > 100) {
            let _ = 1;
        } else {
            let _ = 2;
        };
        // return sum + 5
        sum + 5
    }

    public fun call_lambda(a: u8, b: u8): (u8, u8) {
        let lambda: |u8, u8| (u8, u8) has copy+drop = |x: u8, y: u8| {
            let addition = x + y;
            let multiplication = x * y;
            (addition, multiplication)
        };
        lambda(a, b)
    }
}


//# run 0xCAFE::MathTest::add_and_return_sum --args 50u8 25u8


//# run 0xCAFE::MathTest::call_lambda --args 3u8 7u8


//# publish
module 0xCAFE::NestedCalls {
    use 0xCAFE::MathTest;

    // This inline function calls MathTest::add_and_return_sum internally
    public inline fun call_add_and_add_more(x: u8, y: u8): u8 {
        let intermediate = MathTest::add_and_return_sum(x, y);
        intermediate + 10
    }

    // A public function that calls the inline function above
    public fun nested_call_example(x: u8, y: u8): u8 {
        call_add_and_add_more(x, y)
    }
}


//# run 0xCAFE::NestedCalls::nested_call_example --args 10u8 15u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
