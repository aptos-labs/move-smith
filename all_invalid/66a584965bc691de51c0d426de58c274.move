
//# publish
module 0xCAFE::AdvancedFeatureTest {
    use std::vector;
    use std::signer;

    // A complex struct with nested structs
    struct InnerStruct has copy, drop, store {
        value: u64,
        nested: NestedStruct,
    }

    struct NestedStruct has copy, drop, store {
        label: bool,
        data: u128,
    }

    // Struct with internal function, which should not be accessible externally
    struct Container has store {
        inner: InnerStruct,
    }

    // Internal function to get nested field
    internal fun get_value_from_inner(s: &Container): u64 {
        s.inner.nested.value
    }

    // Public function that accesses nested fields via other functions
    public fun access_nested(s: &Container): u64 {
        get_value_from_inner(s)
    }

    // Function with explicit name and type parameter, calls internal function
    public fun process_generic<T>(val: T): T {
        val
    }

    // Specification function declared as pure for correctness check
    spec pure fun spec_has_value(v: u64): bool {
        v > 0
    }

    // Function with local variables and shadowing in nested scope
    public fun shadow_variable_demo(initial: u64): u64 {
        let outer_var = initial;
        let x = 0u64;
        while (x < 3) {
            let outer_var = outer_var + x; // Shadow outer_var
            let _ = outer_var; // Use shadowed variable
            x = x + 1;
        };
        // Outer variable remains unchanged by inner shadow
        outer_var
    }

    // Function with specification checks, ensuring correctness before execution
    public fun verify_and_process(val: u64): u64 {
        // Assuming the spec check passes (simulate)
        assert!(spec_has_value(val), 999);
        val + 42
    }
}


//# run 0xCAFE::AdvancedFeatureTest::access_nested --args 0xDEAD

//# run 0xCAFE::AdvancedFeatureTest::shadow_variable_demo --args 10u64

//# run 0xCAFE::AdvancedFeatureTest::verify_and_process --args 100u64

//# run 0xCAFE::AdvancedFeatureTest::process_generic --args 123u8


// Featurres:
// 78f8dc464195108ec06049bb15ab9fa2: Access nested fields of expressions using dot notation in Move code.
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
// fdc6779e3d725d21cb1af960a124c0e2: Implement specification checking to ensure that specifications adhere to pureness and correctness standards.
// a0056ab4bdc4a5e262f9b3fda402ab12: Define functions with a name and optional type parameters.
