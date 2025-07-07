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

        let x_mut = x;
        while (x_mut < y) {
            let _old_x = x_mut;
            let _shadow_x = x_mut + 1; // Shadowing variable
            x_mut = _shadow_x;
        };

        // No assertions, just to use variables
        let _ = x_mut;
        let _ = z; // just to keep z used
    }

    // Internal function to be restricted
    fun internal_helper() {
        // Should be restricted to module
        // Not called outside
        let _ = 42u64;
    }

    // Simulation of specification annotation (though just code)
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
        // here, we just convert to a string placeholder
        b"AST_NODE_PLACEHOLDER"
    }

    // Function to trigger warning for calling inline functions internally
    public fun warning_inline_call() {
        // Call to private inline function should generate warning
        // But interpreting, so just call
        inline_helper();
    }

    // Private inline helper
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

// Note: When running tests, ensure you're passing the arguments correctly.
// For example:
// move run --script <script_name.move> --args 10u64 true
// or using the appropriate CLI commands with correct syntax.
//
// You should remove the comment lines starting with 
//# run ... before execution.
// Also, the command-line should not contain inline comments, as the error indicates
// that '//' is not recognized in the arguments.
