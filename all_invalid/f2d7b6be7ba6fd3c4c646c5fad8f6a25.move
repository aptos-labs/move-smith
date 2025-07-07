
//# publish
module 0xCAFE::TestModule {
    use std::signer;
    // use std::debug; // Removed because 'debug' module does not exist or is not available
    // use std::vector; // Removed because 'vector' module is unused and might be invalid in your context

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
        // Reassign 'data1' to new DataHolder
        // Move semantics in Move prevent reassigning a struct unless declared as mutable
        // So declare 'data1' as mutable
        // But in current code, data1 is not mutable; so fix by declaring as mutable
    }

    // Corrected run_variable_tests with mutable data1, data2, data_final
    public fun run_variable_tests(s: signer) {
        let counter: u64 = 0;
        let shadow_var: u64 = 100;
        while (counter < 3) {
            let previous_shadow = shadow_var;
            shadow_var = previous_shadow + 10;
            counter = counter + 1;
        };
        let data1 = DataHolder { value: 0 };
        data1 = DataHolder { value: shadow_var }; // First copy
        let data2 = DataHolder { value: data1.value }; // Copy again
        let data_final = DataHolder { value: data2.value + 5 };

        // Assert final value
        assert!(data_final.value == shadow_var + 5, 999);
    }

    // Function to test internal visibility (should NOT be callable externally)
    fun internal_only_function() {
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
        let s = signer::address_of(&signer::borrow(&signer::new_signer()));
        run_variable_tests(s);
        let flag = named_function_test();
        // Removed debug::print as 'debug' module is not available
        // Optionally, you can have other assertions or logs here if needed
    }
}
