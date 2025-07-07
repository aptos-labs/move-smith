
//# publish
module 0xCAFE::InlineAdd {
    use std::vector;

    // Native struct without fields
    native struct NativeMarker;

    // Inline function for addition of two u8 values
    public inline fun add_u8(a: u8, b: u8): u8 {
        a + b
    }

    // Function with lambda expression that returns the sum of two u8 values
    public fun sum_with_lambda(a: u8, b: u8): u8 {
        let adder: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        adder(a, b)
    }

    // Function that calls the inline add_u8 function multiple times
    public fun nested_add(a: u8, b: u8, c: u8): u8 {
        let ab = add_u8(a, b);
        let result = add_u8(ab, c);
        result
    }

    // Specification block with inline specification inside a function
    public fun spec_with_inline(a: u8, b: u8): u8 {
        spec {
            ensures add_u8(a, b) == a + b;
        };
        add_u8(a, b)
    }
}


//# run 0xCAFE::InlineAdd::add_u8 --args 10u8 15u8


//# run 0xCAFE::InlineAdd::sum_with_lambda --args 20u8 25u8


//# run 0xCAFE::InlineAdd::nested_add --args 1u8 2u8 3u8


//# run 0xCAFE::InlineAdd::spec_with_inline --args 100u8 55u8



//# publish
module 0xCAFE::NestedInlineCall {
    use 0xCAFE::InlineAdd;

    public fun call_inline_add(a: u8, b: u8): u8 {
        let result = InlineAdd::add_u8(a, b);
        result
    }

    public fun call_sum_with_lambda(a: u8, b: u8): u8 {
        let result = InlineAdd::sum_with_lambda(a, b);
        result
    }

    public fun call_nested_add(a: u8, b: u8, c: u8): u8 {
        let result = InlineAdd::nested_add(a, b, c);
        result
    }
}


//# run 0xCAFE::NestedInlineCall::call_inline_add --args 5u8 9u8


//# run 0xCAFE::NestedInlineCall::call_sum_with_lambda --args 7u8 3u8


//# run 0xCAFE::NestedInlineCall::call_nested_add --args 1u8 4u8 5u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 78b50b09721fe7e731c9a18c29a2bb99: Write inline specifications within Move functions to specify behavior.
// e09532b2122bc1456e92219e9f2a0683: Include native structs without field declarations.
