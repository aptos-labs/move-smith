
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
    public fun test_variable_shadowing_and_control(): u64 {
        let x = 5u64;

        let result1 = 0u64;
        let result2 = 0u64;

        // Local variable inside a loop
        let y = x;
        let sum_result1 = result1;
        let sum_result2 = result2;

        let y_loop = y;
        while (y_loop > 0) {
            let y_shadow = y_loop - 1; // shadowing variable
            sum_result1 = sum_result1 + y_shadow;
            y_loop = y_shadow;
        };

        result1 = sum_result1;
        result2 = x;

        // Shadowing outside loop
        let y = x + 10;

        // Sum of variables
        result1 + result2 + y
    }

    // Function to test internal visibility enforcement
    public fun call_internal_helper(x: u64): u64 {
        internal_helper(x)
    }

    // Function to simulate a diagnostic error via verifier mismatch (intentional incorrect code)
    public fun verifier_mismatch() {
        // Intentionally cause bytecode verifier error by creating a mismatch
        // For illustration, perhaps perform an invalid operation or bad code
        // but since such code doesn't compile, we leave placeholder comment
        // e.g., invalid code: *&vec;  // invalid in Move, won't compile
        // We leave the function empty or with a comment
    }

    // Specification function with $ prefix
    public fun $spec_function(x: u64): bool {
        x > 0
    }

    // Function to invoke spec function
    public fun run_spec_function(value: u64): bool {
        $spec_function(value)
    }
}



//# run 0xCAFE::AdvancedFeaturesTest::test_nested_structs --args (res: &mut OuterResource) (1u64, SubResource { detail: true }) (label: "test_label")
    

//# run 0xCAFE::AdvancedFeaturesTest::test_variable_shadowing_and_control --args

//# run 0xCAFE::AdvancedFeaturesTest::call_internal_helper --args 42u64

//# run 0xCAFE::AdvancedFeaturesTest::verifier_mismatch

//# run 0xCAFE::AdvancedFeaturesTest::run_spec_function --args 10u64
