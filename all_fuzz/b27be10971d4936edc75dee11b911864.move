
//# publish
module 0xCAFE::LambdaTest {
    // Test 1: Function that computes addition of two u8 values and returns a specific value.
    public fun add_and_return_special(a: u8, b: u8): u8 {
        let sum = a + b;
        if (sum < 10) {
            42u8
        } else {
            99u8
        }
    }

    // Test 2: Function with lambda (anonymous function) expressions.
    public fun apply_and_sum() {
        let f: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        let val1 = f(3u8, 4u8);
        let val2 = f(10u8, 20u8);

        let g: |u8| u8 has copy+drop = |z: u8| {
            val1 + val2 + z
        };
        let _result = g(5u8);
    }

    // A public inline function to be called from another module to test nested inline function call
    public inline fun inline_for_nested(a: u8): (u8, u8) {
        (a, a + 1)
    }
}


//# publish
module 0xCAFE::NestedInlineCaller {
    use 0xCAFE::LambdaTest;

    // Test 3: Calling an inline function from LambdaTest module using nested function calls.
    public fun nested_inline_call(a: u8): u8 {
        let (x, y) = LambdaTest::inline_for_nested(a);
        let sum = x + y;
        sum
    }
}


//# run 0xCAFE::LambdaTest::add_and_return_special --args 3u8 4u8


//# run 0xCAFE::LambdaTest::apply_and_sum


//# run 0xCAFE::NestedInlineCaller::nested_inline_call --args 5u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
