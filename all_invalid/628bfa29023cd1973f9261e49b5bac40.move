
//# publish
module 0xCAFE::FeatureTest {
    use std::debug;
    use std::vector;

    // Nested struct definitions
    struct InnerStruct has copy, drop, store {
        a: u64,
        b: bool,
    }

    struct OuterStruct has copy, drop, store {
        inner: InnerStruct,
        flag: bool,
    }

    // Function to access nested fields
    public fun access_nested_fields(o: &OuterStruct): u64 {
        o.inner.a
    }

    // Function to test variable scope and while loop
    public fun variable_scope_test() {
        let x = 0u64;
        let y = 10u64;
        let z = 20u64;

        while (x < y) {
            let _old_x = x;
            let _shadow_x = x + 1; // Shadowing variable
            x = _shadow_x;
        };

        // Check that x incremented correctly
        // No assertions, just implicit logic
        let _ = x;
        let _ = z; // just to keep z used
    }

    // Internal function to be restricted
    fun internal_helper() {
        // Should be restricted to module
        // Not called outside
        let _ = 42u64;
    }

    // Specification annotation simulation (ill-formed in code to test)
    public fun annotated_function_with_invariant() {
        // simulate a specification
        // (Real spec would be in the annotations, but here we simulate code)
        let val = 5u64;
        // check invariant: val > 0
        assert!(val > 0, 999);
    }

    // Function to test currying with closures
    public fun apply_closure(x: u64, cond: bool, f: |u64| -> u64): u64 {
        if (cond) {
            f(x)
        } else {
            x
        }
    }

    // Closure examples
    public fun double(n: u64): u64 {
        n * 2
    }

    public fun increment(n: u64): u64 {
        n + 1
    }

    // Function to test function referencing and dereferencing
    public fun reference_test(val: u64): u64 {
        let ref1 = &val;
        let ref2 = &ref1;
        *ref2 // dereferencing twice yields original
    }

    // Function to simulate AST node string representation for debugging
    public fun debug_ast_to_string(node_id: u64): vector<u8> {
        // fake implementation; in reality, would convert AST node to string
        // here, we just convert the id to string
        b"AST_NODE_PLACEHOLDER"
    }

    // Function to trigger warning for calling inline functions internally
    public fun warning_inline_call() {
        // Call to private inline function should generate warning
        // But interpreting, so just call
        inline_helper();
    }

    // Private inline helper
    // inline]
    fun inline_helper() {
        // do nothing
        let _ = 0u8;
    }

    // Function to test referencing and dereferencing parameters
    public fun ref_param_test(param: u64): u64 {
        // multiple immutable references
        let ref1 = &param;
        let ref2 = &ref1;
        *ref2 // should be param
    }
}


//# run 0xCAFE::FeatureTest::access_nested_fields --args 0u64

//# run 0xCAFE::FeatureTest::variable_scope_test


//# run 0xCAFE::FeatureTest::apply_closure --args 10u64 true  // with double closure

//# run 0xCAFE::FeatureTest::apply_closure --args 10u64 false


//# run 0xCAFE::FeatureTest::reference_test --args 123u64


//# run 0xCAFE::FeatureTest::debug_ast_to_string --args 1u64


//# run 0xCAFE::FeatureTest::warning_inline_call


//# run 0xCAFE::FeatureTest::ref_param_test --args 555u64


// Featurres:
// 78f8dc464195108ec06049bb15ab9fa2: Access nested fields of expressions using dot notation in Move code.
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
// fdc6779e3d725d21cb1af960a124c0e2: Implement specification checking to ensure that specifications adhere to pureness and correctness standards.
// 7f343e5b6a46a90c5e940d2d1b876be9: Test that function currying with different closures correctly evaluates conditional logic and produces expected results.
// 21ac1e75f2dd47f51c2bfced1ce8d74d: Convert AST nodes to a string representation for debugging purposes.
// 759d6a677489cb30b1d7f33b9438433d: Display access warnings when inline, non-private functions call functions within the same module, indicating potential access concerns.
// 43c3bcde02206cf7d21abebc2b096576: Test that referencing a function parameter and dereferencing multiple immutable references correctly returns the original value.
