
//# publish
module 0xDEADBEEF::AdvancedFeaturesTest {
    use std::vector;

    // Internal structure for nested mutable structs
    struct InnerStruct has store {
        value: u64,
    }

    struct OuterStruct has store {
        inner: InnerStruct,
        count: u64,
    }

    // Function to be called by script entry point to run the test
    public fun run_advanced_feature_tests() {
        // Call internal functions to verify internal visibility
        internal_test_variable_scoping();
        internal_test_element_for_each_ref();
    }

    // Internal function to test variable assignment and shadowing inside and outside while loop
    fun internal_test_variable_scoping() {
        let outer_var = 100u64;

        let i = 0u64;
        while(i < 3) {
            // Shadowing variable with same name
            let i = i + 1;
            // Local variable shadowing outer `i`—should not affect outer `i`
            let inner_scope_var = i * 2;
            // Update outer_var based on inner scope
            outer_var = outer_var + inner_scope_var;
            // Increment i to proceed loop
            i = i + 1;
        };

        // After loop, outer_var should reflect sum of shadowed variables
        // For illustration, no assertion; just end with outer_var
        outer_var
    }

    // Internal functions to test internal visibility modifiers, not accessible outside
    fun internal_fn_only_for_module() {
        // Does nothing; just a placeholder
    }

    // Function to test elem_for_each_ref over nested mutable structs
    fun internal_test_element_for_each_ref() {
        let vec_structs: vector<OuterStruct> = vector[];
        let i = 0u64;
        while(i < 5) {
            let inner = InnerStruct { value: i * 10};
            let outer = OuterStruct { inner, count: i};
            vector::push_back(&mut vec_structs, outer);
            i = i + 1;
        };

        let total: u64 = 0;

        // Use elem_for_each_ref to modify inner.value and accumulateSum
        vector::elem_for_each_ref(&mut vec_structs, &mut |outer_ref: &mut OuterStruct| {
            outer_ref.inner.value = outer_ref.inner.value + 5;
            total = total + outer_ref.inner.value;
        });

        total
    }
}


//# run 0xDEADBEEF::AdvancedFeaturesTest::run_advanced_feature_tests


// Featurres:
// b70ccb6e356eebb5b3735f5f76cd5273: Write script entry points in Move modules
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
// ef73e9e8f1da23750f1987aec8befa3b: Test that the `elem_for_each_ref` function correctly iterates over mutable fields within nested structs in a vector and accurately applies a provided function to accumulate a result.
