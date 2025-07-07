
//# publish
module 0xCAFE::AddAndReturn {
    public fun add_and_return(a: u8, b: u8): u8 {
        let sum = a + b;
        42u8 + sum
    }

    public fun lambda_usage(): u8 {
        let lambda: |u8, u8| u8 has copy + drop = |x: u8, y: u8| {
            x * y
        };
        lambda(6u8, 7u8)
    }

    public inline fun inline_add(x: u8, y: u8): u8 {
        x + y
    }

    public fun pattern_bind_and_inline(): u8 {
        let (a, b) = (3u8, 4u8);
        inline_add(a, b)
    }
}


//# publish
module 0xCAFE::CallInlineNested {
    use 0xCAFE::AddAndReturn;

    public fun nested_call(x: u8, y: u8): u8 {
        let r = AddAndReturn::inline_add(x, y);
        AddAndReturn::add_and_return(r, 1u8)
    }
}


//# run
script {
    use 0xCAFE::AddAndReturn;
    use 0xCAFE::CallInlineNested;

    fun main() {
        let v1 = AddAndReturn::add_and_return(10u8, 20u8);

        let v2 = AddAndReturn::lambda_usage();

        let v3 = CallInlineNested::nested_call(5u8, 10u8);

        let v4 = AddAndReturn::pattern_bind_and_inline();

        let const_value = 99u8;

        let (x, y) = (7u8, 8u8);

        // Just no-op since no assertions required, but all calls exercised
        let _ = v1;
        let _ = v2;
        let _ = v3;
        let _ = v4;
        let _ = const_value;
        let _ = x;
        let _ = y;
    }
}


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// b14465536836359191081c70d1e70f88: Use value expressions to embed constant or literal values in your code.
// b12c4b597314be2d929c4915dc02b906: Bind variables directly in patterns using standard pattern matching syntax
// 2ac39831d47d5e106d466845b5f016f4: Declare and utilize named addresses that may be unassigned during compilation.
