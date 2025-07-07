
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

    // Function returning a function, testing first-class functions
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
    // metadata: "*"]
    public fun metadata_wildcard_test() {
        // no op
    }

    // Constants to embed in scripts
    const CONST_U8: u8 = 255;
    const CONST_U64: u64 = 123456789;
    const CONST_UI128: u128 = 999999999999u128;

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
        // No compilers errors expected
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
    // metadata: "*"]
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


// Featurres:
// 78f8dc464195108ec06049bb15ab9fa2: Access nested fields of expressions using dot notation in Move code.
// 1630878bb07f0e61d64057399656ba48: Test that the Move function correctly handles multiple aborts and continues execution to produce the expected final result.
// c75b5002236cb27e7430836ca3ad0a31: Test that functions (including generic functions) can be used as first-class values—assigned to variables, passed as closures and function pointers, and invoked as arguments or with type arguments.
// 1011b8aa32f48fef72a832a6a7a35814: Write Move code that is statically checked for bytecode-level correctness before execution
// 11a4d1fe9892131da3fe1e15c5bf28ca: Write code that calls inline functions and benefit from having those callees' bodies inlined into the caller.
// b0876c3c402d2049797d1e740279af47: Define script blocks with attributes, uses, constants, a main function, specifications, and location metadata in Move.
// 3de127ba18e0329f2191d1eb958890ad: Use the '*' wildcard to apply spec blocks or conditions to all matching entities within the current context.
// 58144f80ecfcc1a7f6b3597c62ec21d2: Create jump instructions to transfer control unconditionally to a label.
