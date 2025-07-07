
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
    // Note: function-typed parameters to inline functions must be literal lambdas
    public inline fun foo_apply(x: u8, f: |u8|u8, g: |u8|u8): u8 {
        let r1 = f(x);
        let r2 = g(x);
        r1 + r2
    }

    public fun use_foo_apply(): u8 {
        // Pass literal lambda expressions directly, not variables
        foo_apply(4, |a: u8| { a + 1 }, |a: u8| { a * 2 })
    }
}



//# run 0xCAFE::LambdaAndInlineTest::add_two_u8 --args 3u8 4u8


//# run 0xCAFE::LambdaAndInlineTest::use_lambdas --args 3u8 5u8


//# run 0xCAFE::LambdaAndInlineTest::call_foo_and_destructure --args 10u16


//# run 0xCAFE::LambdaAndInlineTest::use_foo_apply
