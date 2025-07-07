
//# publish
module 0xCAFE::MathTest {
    // Module to test addition and lambdas

    public fun add_two_u8(a: u8, b: u8): u8 {
        let sum = a + b;
        if (sum > 255) {
            // u8 overflow is checked by VM, no need for extra code here.
        };
        42  // Always return 42 regardless of sum to test return value correctness
    }

    public fun with_lambda(a: u8, b: u8): u8 {
        let add_lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| { x + y };
        let result = add_lambda(a, b);

        let double_lambda: |u8| u8 has copy+drop = |x: u8| { x * 2 };

        let doubled = double_lambda(result);
        doubled
    }
}


//# publish
module 0xCAFE::NestedCallTest {
    use 0xCAFE::MathTest;

    public inline fun inline_add(a: u8, b: u8): u8 {
        let res = a + b;
        res
    }

    public fun call_inline_add_twice(x: u8): u8 {
        let first = inline_add(x, 1);
        let second = inline_add(first, 2);
        second
    }

    public fun call_add_two_u8_and_with_lambda(x: u8, y: u8): (u8, u8) {
        let r1 = MathTest::add_two_u8(x, y);
        let r2 = MathTest::with_lambda(x, y);
        (r1, r2)
    }
}


//# run 0xCAFE::MathTest::add_two_u8 --args 10u8 32u8


//# run 0xCAFE::MathTest::with_lambda --args 5u8 7u8


//# run 0xCAFE::NestedCallTest::call_inline_add_twice --args 10u8


//# run 0xCAFE::NestedCallTest::call_add_two_u8_and_with_lambda --args 1u8 2u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
