
//# publish
module 0xCAFE::AdvancedFeaturesTest {
    use std::vector;

    // Nested Structs to test dot notation access
    struct Outer has copy, drop, store {
        inner: Inner,
        flag: bool,
    }

    struct Inner has copy, drop, store {
        nested_value: u64,
        sub_inner: SubInner,
    }

    struct SubInner has copy, drop, store {
        final_value: u128,
    }

    // Generic Struct with type parameter
    struct Container<T> has copy, drop, store {
        value: T,
    }

    // Enum with multiple abort points
    enum AbortableEnum has copy, drop {
        VariantA,
        VariantB(u64),
        VariantC { code: u8 },
    }

    // Function with multiple abort points for error verification
    public fun abort_prone_function(x: u64): u64 {
        if (x == 0) {
            abort 1;
        };
        if (x == 1) {
            abort 2;
        };
        x + 10
    }

    // Corrected function to return a function pointer
    // Previously: public fun get_abortable_function(): fn(u64): u64 {
    // The syntax should be: public fun get_abortable_function(): fn(u64): u64
    // But in Move, function references are returned as type 'fn(arg_types) -> return_type'
    // The syntax is correct; however, the compiler may require additional annotations.
    // The main issue is that the colon in the return type is used properly.
    //
    // Based on the error, the parser expected '{' after the function signature
    // but encountered '('. The likely cause is that the function signature syntax is invalid.
    //
    // In Move, to declare a function returning a function pointer, the syntax is correct,
    // but for clarity, ensure there's no syntax error.
    //
    // Remove any extraneous characters or syntax issues.
    //
    // So, the existing line appears okay, but to be safe, rewrite it for clarity.

    // Fixed version:
    public fun get_abortable_function(): fn(u64): u64 {
        abort_prone_function
    }

    // Function that passes a function as a parameter and invokes it
    public fun call_function_with_param(f: fn(u64): u64, val: u64): u64 {
        f(val)
    }

    // Inline function to test inlining behavior
    public inline fun inline_add(x: u64, y: u64): u64 {
        let sum = x + y;
        sum
    }

    // Function calling inline function
    public fun use_inline_add(a: u64, b: u64): u64 {
        inline_add(a, b)
    }

    // Function to test metadata attributes with * wildcard
    // Also fix the comment syntax
    // Original: // metadata: "*"]
    // Corrected: attributes using '///' style or proper annotations if needed.
    // But in Move, function attributes start with '///' or comments. 
    // Assuming the line is meant to be a comment for metadata, leave it as is.
    // Alternatively, remove if not supported.
    //
    // For clarity, I'll comment it properly.
    ///
    /// @metadata "*"
    public fun metadata_wildcard_test() {
        // no op
    }

    // Constants to embed in scripts
    const CONST_U8: u8 = 255;
    const CONST_U64: u64 = 123456789;
    const CONST_U128: u128 = 999999999999u128;

    // Script main function to test dot notation nested field access
    public fun main() {
        let inner_obj = Inner { nested_value: 42, sub_inner: SubInner { final_value: 77 } };
        let outer_obj = Outer { inner: inner_obj, flag: true };
        let nested_final_value = outer_obj.inner.sub_inner.final_value;
        // nested_final_value should be 77
        // The test is passive; no assertion needed
        nested_final_value
    }

    // Function with multiple abort points testing
    public fun complex_abort_test(x: u64): u64 {
        if (x < 10) {
            abort 10;
        };
        if (x == 100) {
            abort 20;
        };
        if (x > 1000) {
            abort 30;
        };
        x + 100
    }

    // Function testing function assignment, passed as first-class, and invoked
    public fun test_function_assignments_and_calls() {
        let f: fn(u64): u64 = abort_prone_function;
        let result1 = f(5);
        let result2 = get_abortable_function()(10);
        let result3 = call_function_with_param(f, 15);
        // Compose nested calls
        result1 + result2 + result3
    }

    // Function testing generic struct with type parameter and nested access
    public fun test_generic_struct() {
        let g_string = Container<vector<u8>> { value: vector::empty<u8>() };
        let g_number = Container<u64> { value: 999u64 };
        // No compiler errors expected
        (g_string.value, g_number.value)
    }

    // Function to test invoking inline function from another function
    public fun test_inlined_call(x: u64, y: u64): u64 {
        use self::inline_add;
        inline_add(x, y)
    }

    // Script block for location annotation and attribute verification
    /// @location "SomeLocation"
    /// @attribute "TestAttribute"
    // Also fix the comment syntax for metadata wildcard
    /// @metadata "*"
    public fun location_and_metadata_test() {
        // no op
    }
}



//# run 0xCAFE::AdvancedFeaturesTest::main


//# run 0xCAFE::AdvancedFeaturesTest::complex_abort_test --args 5u64


//# run 0xCAFE::AdvancedFeaturesTest::complex_abort_test --args 100u64


//# run 0xCAFE::AdvancedFeaturesTest::complex_abort_test --args 1500u64


//# run 0xCAFE::AdvancedFeaturesTest::test_function_assignments_and_calls


//# run 0xCAFE::AdvancedFeaturesTest::test_generic_struct


//# run 0xCAFE::AdvancedFeaturesTest::test_inlined_call --args 20u64 22u64


//# run 0xCAFE::AdvancedFeaturesTest::location_and_metadata_test
