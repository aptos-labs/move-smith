
//# publish
module 0xCAFE::AdvancedFeaturesTest {
    use std::vector;

    // Define a nested structure
    struct InnerResource has store, key {
        value: u64,
        sub: SubResource,
    }

    struct SubResource has store {
        detail: bool,
    }

    struct OuterResource has store, key {
        nested: InnerResource,
        label: vector<u8>,
    }

    // Internal function that cannot be called outside this module
    fun internal_helper(x: u64): u64 {
        x + 10
    }

    // Public function to get nested field data
    public fun get_nested_value(res: &OuterResource): u64 {
        res.nested.value
    }

    // Public function to mutate nested field
    public fun mutate_nested_value(res: &mut OuterResource, new_value: u64) {
        res.nested.value = new_value;
    }

    // Function to test nested field access and mutation
    public fun test_nested_structs(res: &mut OuterResource): u64 {
        // Access nested field
        let value = get_nested_value(res);
        // Mutate nested value
        mutate_nested_value(res, value + 100);
        // Return new nested value
        get_nested_value(res)
    }

    // Function to test variable shadowing and control flow
    public fun test_variable_shadowing_and_control() {
        let x = 5u64;

        let result1 = 0u64;
        let result2 = 0u64;

        // Local variable inside a loop
        let y = x;
        while (y > 0) {
            let y = y - 1; // shadowing variable
            result1 = result1 + y;
        };

        // Variable outside loop remains unchanged
        result2 = x;

        // Shadowing outside loop
        let y = x + 10;

        // Mutate variables
        result1 + result2 + y
    }

    // Function to test internal visibility enforcement
    public fun call_internal_helper(x: u64): u64 {
        internal_helper(x)
    }

    // Function to simulate a diagnostic error via verifier mismatch (intentional incorrect code)
    public fun verifier_mismatch() {
        // Intentionally cause bytecode verifier error by creating a mismatch
        // E.g., returning a type incompatible with the function's signature
        let bad_value = *&vec; // invalid bytecode, but just for illustration
        // Note: In actual Move, such code won't compile, so we simulate with a known error
    }

    // Specification function with $ prefix
    public fun $spec_function(x: u64): bool {
        x > 0
    }

    // Function to invoke spec function
    public fun run_spec_function(value: u64): bool {
        // Expect compiler to recognize $prefixed function as spec
        $spec_function(value)
    }
}


//# run 0xCAFE::AdvancedFeaturesTest::test_nested_structs --args (res: &mut OuterResource) (1u64, SubResource { detail: true }) (label: "test_label")
    

//# run 0xCAFE::AdvancedFeaturesTest::test_variable_shadowing_and_control


//# run 0xCAFE::AdvancedFeaturesTest::call_internal_helper --args 42u64


//# run 0xCAFE::AdvancedFeaturesTest::verifier_mismatch


//# run 0xCAFE::AdvancedFeaturesTest::run_spec_function --args 10u64


// Featurres:
// 78f8dc464195108ec06049bb15ab9fa2: Access nested fields of expressions using dot notation in Move code.
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
// fefd36857fb737b210012bc5a2b3b39d: Trigger compiler diagnostics when bytecode verifier mismatches occur in user code
// f34037df361042e434a38b0acdc1e255: Define specification functions with names prefixed by '$' to indicate special purpose functions.
