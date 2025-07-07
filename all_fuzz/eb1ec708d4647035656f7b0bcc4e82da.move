
//# publish
module 0xCAFE::LambdaTest {
    // Define a function that adds two u8 and returns the sum plus a constant
    public fun add_then_increment(a: u8, b: u8): u8 {
        let sum = a + b;

        let lambda: |u8|u8 has copy+drop = |x: u8| {
            x + 5u8
        };
        lambda(sum)
    }

    // A lambda function that takes two u8 and returns their product
    public fun multiply_lambda(a: u8, b: u8): u8 {
        let mul: |u8, u8|u8 has copy+drop = |x: u8, y: u8| {
            x * y
        };
        mul(a, b)
    }

    // Inline function that returns a tuple, defined here for nested call test
    public inline fun inline_additions(x: u16): (u16, u16) {
        (x + 10, x + 20)
    }

    // Calls the inline function above and returns sum of the returned tuple
    public fun test_inline_call(x: u16): u16 {
        let (a, b) = inline_additions(x);
        a + b
    }
}


//# publish
module 0xCAFE::NestedCallTest {
    use 0xCAFE::LambdaTest;

    // Calls the inline function in LambdaTest via a wrapper function
    public fun call_inline_nested(x: u16): u16 {
        LambdaTest::test_inline_call(x)
    }
}


//# run 0xCAFE::LambdaTest::add_then_increment --args 10u8 15u8


//# run 0xCAFE::LambdaTest::multiply_lambda --args 4u8 5u8


//# run 0xCAFE::NestedCallTest::call_inline_nested --args 5u16


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
