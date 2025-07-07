
//# publish
module 0xCAFE::Addition {
    // Basic addition function that adds two u8 values and returns the sum plus a constant offset
    public fun add_and_offset(a: u8, b: u8): u8 {
        a + b + 5u8
    }

    // Function containing a simple lambda that computes product and sum of two u8 values
    public fun lambda_test(a: u8, b: u8): (u8, u8) {
        let f: |u8, u8| (u8, u8) has copy+drop = |x: u8, y: u8| {
            (x + y, x * y)
        };
        f(a, b)
    }

    // Inline function to be called from another module
    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }

    // Struct with and without type parameters
    struct WithTypeParam<T> has copy, drop {
        field: T
    }

    struct WithoutTypeParam has copy, drop {
        a: u8,
        b: u8,
    }

    // Runner function for tests within this module
    public fun test_runner(): u8 {
        let (sum, product) = lambda_test(3u8, 4u8);
        let res = add_and_offset(sum, product);
        res
    }
}



//# run 0xCAFE::Addition::add_and_offset --args 10u8 15u8



//# run 0xCAFE::Addition::lambda_test --args 7u8 8u8



//# run 0xCAFE::Addition::test_runner




//# publish
module 0xCAFE::NestedCalls {
    use 0xCAFE::Addition;

    // Removed friend declaration to avoid cyclic dependency error

    public fun call_inline_add(a: u8, b: u8): u8 {
        Addition::inline_add(a, b)
    }

    // Call test_runner from Addition module and add an offset
    public fun combined_test(): u8 {
        let base = Addition::test_runner();
        base + 10u8
    }
}



//# run 0xCAFE::NestedCalls::call_inline_add --args 20u8 22u8



//# run 0xCAFE::NestedCalls::combined_test


// Features:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 019ec2b7f93cdef7c0d68e32b8cead1c: Annotate a friend declaration with attributes to specify custom metadata or behavior.
// e5adf4976fe395c702e53fe71ae35f0d: Define Move struct fields that use or do not use type parameters
