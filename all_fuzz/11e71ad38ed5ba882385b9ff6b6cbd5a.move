
//# publish
module 0xCAFE::MathUtils {
    public inline fun add_two_u8(a: u8, b: u8): u8 {
        a + b
    }

    public fun add_then_increment(a: u8, b: u8): u8 {
        let sum = add_two_u8(a, b);
        sum + 1
    }

    public fun double_lambda(x: u8): u8 {
        let lambda: |u8| u8 has copy + drop = |v: u8| {
            v * 2
        };
        let result = lambda(x);
        result
    }
}


//# run 0xCAFE::MathUtils::add_then_increment --args 5u8 7u8


//# run 0xCAFE::MathUtils::double_lambda --args 4u8


//# publish
module 0xCAFE::NestedCalls {
    use 0xCAFE::MathUtils;

    public fun nested_add_then_increment(a: u8, b: u8): u8 {
        // Call the inline function from MathUtils multiple times and combine results
        let first = MathUtils::add_two_u8(a, b);
        let second = MathUtils::add_then_increment(a, b);
        first + second
    }
}


//# run 0xCAFE::NestedCalls::nested_add_then_increment --args 3u8 6u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
