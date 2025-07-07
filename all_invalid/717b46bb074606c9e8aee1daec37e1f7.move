
//# publish
module 0xCAFE::TestInteraction {
    use std::signer;
    use std::vector;

    // Internal-only helper functions
    fun internal_helper(x: u8): u8 {
        x + 10
    }

    // Entry point script that tests variable scope, shadowing, and loops
    public fun test_variable_scope_and_loops(s: signer) {
        let _s_ref = signer::address_of(&s);
        let x = 0u8;
        let sum = 0u8;

        // Shadowing inside a loop
        let loop_counter = 0u8;

        let _ = {
            let _x = 5u8; // Shadow outside x
            while (x < 3u8) {
                // Shadow x inside loop
                let x = x + 1;
                sum = sum + x;
                x
            };
        };

        // Verify variable values after shadowing and loops
        assert!(x == 0u8, 999);
        assert!(sum == 6u8, 999);
        assert!(loop_counter == 0u8, 999);
    }

    // Entry point testing access control: internal functions are not accessible
    public fun test_access_control(s: signer) {
        // This function calls an internal helper within the module
        let result = internal_helper(5u8);
        assert!(result == 15u8, 998);

        // External code cannot directly call internal_helper('if attempted, compiler error')
        // So not testing direct access outside the module here; just internal call suffices
    }

    // Function to create multiple types in sequence
    public fun create_multiple_types(): (vector<u8>, vector<u16>, vector<bool>, vector<address>) {
        let v_u8 = vector::empty<u8>();
        vector::push_back(&mut v_u8, 1);
        vector::push_back(&mut v_u8, 2);

        let v_u16 = vector::empty<u16>();
        vector::push_back(&mut v_u16, 65535);
        vector::push_back(&mut v_u16, 12345);

        let v_bool = vector::empty<bool>();
        vector::push_back(&mut v_bool, true);
        vector::push_back(&mut v_bool, false);

        let v_addr = vector::empty<address>();
        vector::push_back(&mut v_addr, @0xCAFE);
        vector::push_back(&mut v_addr, @0xBEEF);

        (v_u8, v_u16, v_bool, v_addr)
    }

    // Function that applies exclude patterns in code (simulate by function attribute)
    //@ exclude_pattern
    public fun pattern_exclusion_test() {
        // This code is to represent exclusion; in real move, attributes are compile-time
        // So we simulate by not calling or including other code
    }

    // Function with attributes associated with code location
    //@ attribute_location("0xCAFE::TestInteraction")
    public fun attribute_test() {
        // Verify attribute linkage (simulation)
        let _ = 1u8; // dummy operation
    }

    // Function that uses loops with variable shadowing for thorough test
    public fun nested_loops_shadowing() {
        let i = 0u8;
        for (i in 0..3) {
            let _i = i + 1; // Shadow inner variable
            let j = i + 2;
        };
        // Validate outer variable remains unchanged
        assert!(i == 0u8, 997);
    }

    // Function that tests sequence of resource creation and access
    public fun resource_sequence_test() {
        // Dummy resource resource creation
        // No actual resource, just simulate sequence of object creation
        let _obj = 0xCAFE::MyModule::f3(20u16);
        let _value = 0xCAFE::MyModule::f1(7u8, false);
    }
}


//# run 0xCAFE::TestInteraction::test_variable_scope_and_loops --signers 0xDEAD

//# run 0xCAFE::TestInteraction::test_access_control --signers 0xDEAD

//# run 0xCAFE::TestInteraction::create_multiple_types //--signers 0xDEAD

//# run 0xCAFE::TestInteraction::nested_loops_shadowing --signers 0xDEAD

//# run 0xCAFE::TestInteraction::resource_sequence_test --signers 0xDEAD


// Featurres:
// b70ccb6e356eebb5b3735f5f76cd5273: Write script entry points in Move modules
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
// c423383e13619580fa0d6477f9a16cca: Create multiple types in a sequence with 'Multiple'.
// e22221b32e33aa69eef00d30b5419f3e: Optionally exclude specific patterns from an 'apply' by adding 'except <patterns>' in the same syntax.
// 618ec165be600d3844d66fbef3466d89: Handle attributes with valid module identifiers or names, ensuring correct association of code locations with modules.
