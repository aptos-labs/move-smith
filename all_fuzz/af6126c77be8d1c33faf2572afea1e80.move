
//# publish
module 0xCAFE::Additions {
    public fun add_two_values(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return a specific value plus sum (e.g., 10 + sum)
        10 + sum
    }

    public fun use_lambda(): u8 {
        let adder: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        adder(5u8, 7u8)
    }

    public inline fun inline_add_and_double(x: u8, y: u8): u8 {
        let s = add_two_values(x, y);
        s * 2
    }
}


//# run 0xCAFE::Additions::add_two_values --args 3u8 4u8


//# run 0xCAFE::Additions::use_lambda


//# publish
module 0xCAFE::NestedCalls {
    use 0xCAFE::Additions;

    public fun nested_call(x: u8, y: u8): u8 {
        let sum = Additions::add_two_values(x, y);
        let doubled = Additions::inline_add_and_double(x, y);
        sum + doubled
    }

    public fun call_inline_from_nested(): u8 {
        // Call the inline function from Additions module
        Additions::inline_add_and_double(1u8, 2u8)
    }
}


//# run 0xCAFE::NestedCalls::nested_call --args 2u8 5u8


//# run 0xCAFE::NestedCalls::call_inline_from_nested


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
