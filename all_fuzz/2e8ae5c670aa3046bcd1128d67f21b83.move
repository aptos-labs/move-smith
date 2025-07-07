
//# publish
module 0xCAFE::AddAndLambda {
    // This module tests addition of two u8 and lambda expressions.

    // Simple add function returning sum + 10
    public fun add_and_offset(x: u8, y: u8): u8 {
        let sum = x + y;
        sum + 10
    }

    // Function with lambda taking two u8 and applying an operation (multiply + 1)
    public fun lambda_multiply_plus_one(x: u8, y: u8): u8 {
        let op: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a * b + 1
        };
        op(x, y)
    }

    // Runner to exercise functions above without arguments
    public fun runner() {
        let _ = add_and_offset(5u8, 10u8);
        let _ = lambda_multiply_plus_one(3u8, 4u8);
    }
}


//# run 0xCAFE::AddAndLambda::add_and_offset --args 7u8 8u8


//# run 0xCAFE::AddAndLambda::lambda_multiply_plus_one --args 2u8 3u8


//# run 0xCAFE::AddAndLambda::runner



//# publish
module 0xCAFE::NestedInlineFunc {
    use 0xCAFE::AddAndLambda;

    // Inline function returning tuple (a+1, a+2)
    public inline fun inline_increment(a: u16): (u16, u16) {
        (a + 1, a + 2)
    }

    // Function calling inline function from this module and nested call from AddAndLambda's add_and_offset
    public fun nested_calls(x: u8, y: u8, z: u16): u8 {
        // call inline_increment
        let (a, b) = inline_increment(z);
        // call add_and_offset from AddAndLambda with sum of x and y cast to u8
        let sum = AddAndLambda::add_and_offset(x, y);
        let result = sum + (a as u8) + (b as u8);
        result
    }

    // Runner to test nested_calls
    public fun runner() {
        let _ = nested_calls(4u8, 6u8, 10u16);
    }
}


//# run 0xCAFE::NestedInlineFunc::nested_calls --args 1u8 2u8 5u16


//# run 0xCAFE::NestedInlineFunc::runner


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
