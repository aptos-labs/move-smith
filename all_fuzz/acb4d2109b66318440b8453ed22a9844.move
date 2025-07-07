
//# publish
module 0xCAFE::LambdaTest {
    // LambdaTest module to test lambda expressions and nested function calls

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }

    public fun call_inline_add_and_return_sum(x: u8, y: u8): u8 {
        let sum = inline_add(x, y);
        // Define a lambda that adds sum and a given input
        let adder: |u8|u8 has copy+drop = |z: u8| {
            sum + z
        };
        adder(10u8)
    }

    public fun lambda_test_addition(x: u8, y: u8): u8 {
        let add_lambda: |u8, u8|u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        add_lambda(x, y)
    }

    public fun identify_modified_variables(x: u8, y: u8): u8 {
        let mut_x = x + 1u8;
        let mut_y = y + 1u8;
        if (mut_x > mut_y) {
            let mut_x2 = mut_x + mut_y;
        } else {
            let mut_y2 = mut_x * mut_y;
        };
        mut_x + mut_y
    }
}


//# run 0xCAFE::LambdaTest::lambda_test_addition --args 5u8 7u8


//# run 0xCAFE::LambdaTest::call_inline_add_and_return_sum --args 3u8 4u8


//# run 0xCAFE::LambdaTest::identify_modified_variables --args 8u8 2u8



//# publish
module 0xCAFE::CallInline {
    use 0xCAFE::LambdaTest;

    public fun call_nested_inline(x: u8, y: u8): u8 {
        LambdaTest::call_inline_add_and_return_sum(x, y)
    }
}


//# run 0xCAFE::CallInline::call_nested_inline --args 2u8 3u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 2b6bfcc30072353846ac0500ff65e4a8: Avoid attaching duplicate attributes with the same name to a single item.
// 22d822f16140247516b77e9ba11bc63f: Identify variables that are possibly modified within a scope.
