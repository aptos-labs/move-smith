
//# publish
module 0xCAFE::Math {
    struct Pair has copy, drop, store {
        a: u8,
        b: u8,
    }

    enum ResultEnum has copy, drop {
        Ok(u8),
        Error(u8),
    }

    // Add two u8 values and return sum plus 5 to test computation
    public fun add_with_offset(x: u8, y: u8): u8 {
        let sum = x + y;
        sum + 5
    }

    // A function containing a lambda that increments input by 10
    public fun lambda_increment(x: u8): u8 {
        let increment_by_ten: |u8|u8 has copy+drop = |val: u8| {
            val + 10
        };
        increment_by_ten(x)
    }

    // Inline function that returns the sum of two u8s
    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }

    // Struct containing a nested struct
    struct Outer has copy, drop, store {
        inner: Pair,
    }

    // Function to return sum by accessing nested fields with dot notation
    public fun nested_field_sum(): u8 {
        let p = Pair { a: 2u8, b: 3u8 };
        let o = Outer { inner: p };
        let val = o.inner.a + o.inner.b;
        val
    }
}


//# run 0xCAFE::Math::add_with_offset --args 3u8 4u8


//# run 0xCAFE::Math::lambda_increment --args 5u8


//# publish
module 0xCAFE::Caller {
    use 0xCAFE::Math;

    // Call inline_add from Math module to test nested calls and inline function usage
    public fun test_nested_inline_call(x: u8, y: u8): u8 {
        Math::inline_add(x, y)
    }

    // Call Math::nested_field_sum to test access to nested field values
    public fun call_nested_field_sum(): u8 {
        Math::nested_field_sum()
    }
}


//# run 0xCAFE::Caller::test_nested_inline_call --args 7u8 8u8


//# run 0xCAFE::Caller::call_nested_field_sum


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 78f8dc464195108ec06049bb15ab9fa2: Access nested fields of expressions using dot notation in Move code.
// ee2f45bc2ad7ed5a6ecea83d00cd9342: Define structs and enum structures within modules.
