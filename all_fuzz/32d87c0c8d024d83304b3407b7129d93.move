
//# publish
module 0xCAFE::MathTest {
    // Test addition u8 and return computed before fixed u8
    public fun add_then_return_fixed(a: u8, b: u8): u8 {
        let sum = a + b;
        // discard sum, return fixed value 42
        42u8
    }

    // Function containing lambda (anonymous function) to multiply by 2
    public fun apply_lambda_double(x: u8): u8 {
        let double_fn: |u8| u8 has copy+drop = |n: u8| {
            n * 2
        };
        double_fn(x)
    }

    // Inline function computing (a + 1, b + 2)
    public inline fun inline_add_offsets(a: u8, b: u8): (u8, u8) {
        (a + 1, b + 2)
    }
}


//# publish
module 0xCAFE::NestedCallTest {
    use 0xCAFE::MathTest;

    // Call MathTest::inline_add_offsets within another function
    public fun call_inline_and_sum(a: u8, b: u8): u8 {
        let (a_off, b_off) = MathTest::inline_add_offsets(a, b);
        a_off + b_off
    }
}


//# run 0xCAFE::MathTest::add_then_return_fixed --args 10u8 20u8


//# run 0xCAFE::MathTest::apply_lambda_double --args 21u8


//# run 0xCAFE::NestedCallTest::call_inline_and_sum --args 5u8 10u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
