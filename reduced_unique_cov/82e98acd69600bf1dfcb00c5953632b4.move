
//# publish
module 0xCAFE::LambdaAndInlineTest {
    // Test Point 1: add_two_u8 returns sum + 10
    public fun add_two_u8(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 10
    }

    // Test Point 2: function using lambdas (anonymous functions)
    public fun use_lambdas(x: u8, y: u8): u8 {
        let add = |a: u8, b: u8| { a + b };
        let mul = |a: u8, b: u8| { a * b };

        let sum = add(x, y);
        let product = mul(x, y);

        // Return sum + product
        sum + product
    }

    // Inline function to be called from another module, returns (a+1, a+2)
    public inline fun foo(a: u16): (u16, u16) {
        (a + 1, a + 2)
    }

    // Test Point 3 & 4: call the inline foo from this module and destructure
    public fun call_foo_and_destructure(a: u16): u32 {
        let (b, c) = foo(a);
        (b as u32) + (c as u32)
    }

    // Test Point 5: inline function foo_apply, applies two functions to x and returns their sum
    public inline fun foo_apply(x: u8, f: |u8|u8, g: |u8|u8): u8 {
        let r1 = f(x);
        let r2 = g(x);
        r1 + r2
    }

    public fun use_foo_apply(): u8 {
        let f = |a: u8| { a + 1 };
        let g = |a: u8| { a * 2 };
        foo_apply(4, f, g)
    }
}


//# run 0xCAFE::LambdaAndInlineTest::add_two_u8 --args 3u8 4u8


//# run 0xCAFE::LambdaAndInlineTest::use_lambdas --args 3u8 5u8


//# run 0xCAFE::LambdaAndInlineTest::call_foo_and_destructure --args 10u16


//# run 0xCAFE::LambdaAndInlineTest::use_foo_apply


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 6ddbaac7fd4a97dd727f7448a5805473: Use let bindings that destructure or bind multiple values ('lvalues') with corresponding expressions on the right-hand side in a single statement
// 408d8aea1db5f94f33bb4ad7c6794460: Test that the `inline` function `foo` correctly applies its function parameters to the argument `x` and returns their sum.
