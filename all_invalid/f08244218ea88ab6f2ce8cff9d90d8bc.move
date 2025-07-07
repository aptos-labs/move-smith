
//# publish
module 0xCAFE::TestModule {
    use std::signer;
    use std::debug;
    use std::vector;

    // Struct for comparison tests
    struct DataHolder has copy, drop, store {
        value: u64
    }

    // Internal function (can't be called from outside) to verify access restrictions
    fun internal_verify_access() {
        // No implementation needed, just testing internal visibility
    }

    // Entry point: simulate variable assignment, loop, shadowing, and copying data
    public fun run_variable_tests(s: signer) {
        let counter: u64 = 0;
        let shadow_var: u64 = 100;
        // Loop: increment counter, shadow variable within loop
        while (counter < 3) {
            let previous_shadow = shadow_var;
            shadow_var = previous_shadow + 10;
            counter = counter + 1;
        };
        // Copy value into struct multiple times
        let data1 = DataHolder { value: 0 };
        data1 = DataHolder { value: shadow_var }; // First copy
        let data2 = DataHolder { value: data1.value }; // Copy again

        // Final assignment to verify data retention
        let data_final = DataHolder { value: data2.value + 5 };

        // Assert final value
        assert!(data_final.value == shadow_var + 5, 999);
    }

    // Function to test internal visibility (should NOT be callable externally)
    fun internal_only_function() {
        // Can call internal function within module
        internal_verify_access();
    }

    // Function with a name that does not start with underscore, to confirm recognition
    public fun named_function_test(): bool {
        true
    }

    // Function to compare u64 values for equality
    public fun compare_u64s(a: u64, b: u64): bool {
        a == b
    }

    // Function to compare complex structs for equality
    public fun compare_dataholders(d1: &DataHolder, d2: &DataHolder): bool {
        d1.value == d2.value
    }

    // Internal function that should not be accessible outside
    fun internal_hidden() {
        // implementation placeholder
    }

    // Runner function that calls run_variable_tests with a signer
    public fun run_all_tests() {
        let s = signer::address_of(&signer::borrow(&signer::new_signer()), 1);
        run_variable_tests(s);
        // Call named function to confirm recognition
        let flag = named_function_test();
        debug::print(&flag);
    }
}


//# run 0xCAFE::TestModule::run_all_tests --signers 0xBADD


// Featurres:
// b70ccb6e356eebb5b3735f5f76cd5273: Write script entry points in Move modules
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
// 2da1f2b35c702c52170a944bcb8b662f: Define function names that do not start with an underscore ('_').
// 2b278529463232504c0d1bfc362f60dd: Verify that a sequence of variable assignments correctly retains the original values and results in the expected struct after sequential copying.
// 03c60ac174e683c8896c630039c7b951: Verify that the equality functions correctly compare u64 values and custom struct instances with a u64 field.
