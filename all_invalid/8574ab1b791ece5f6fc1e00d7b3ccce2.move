//# publish
module 0xCAFE::InteractionTests {
    use std::signer;
    use std::vector;
    use std::debug;

    // Define a structure with internal (private) functions for testing access restrictions
    struct PrivateStruct has store, key {
        value: u64,
    }

    // Example internal (private) function
    public fun internal_increment(s: &mut PrivateStruct) {
        s.value = s.value + 1;
    }

    // Example internal function that cannot be called from outside
    fun internal_fail() {
        // do nothing
    }

    // Entry point to execute internal functions for testing
    public fun run_internal_tests() {
        let s = &mut PrivateStruct { value: 0 };
        internal_increment(s);
        internal_increment(s);
        // can't call internal_fail() from outside, so no direct check here
    }

    // Helper functions for reference mutability
    public fun modify_value_ref(s: &mut u64, delta: u64) {
        *s = *s + delta;
    }

    public fun read_value_ref(s: &u64): u64 {
        *s
    }

    // Test function to evaluate nested variable scoping, shadowing, and loop behaviors
    // test]
    public fun variable_shadowing_and_loops_test() {
        let outer_var: u64 = 100;
        let inner_var: u64 = 0;

        // Inner scope: shadowing outer_var
        {
            let outer_var: u64 = 50; // shadowed copy
            let loop_var: u64 = 0;

            // Loop: increment loop_var until 5
            while (loop_var < 5) {
                loop_var = loop_var + 1;
            };  // semicolon added here
            // after loop, loop_var should be 5
            assert!(loop_var == 5, 999);
        }

        // outer_var should remain unchanged
        assert!(outer_var == 100, 1000);

        // Loop to update inner_var
        let inner_var_mut = inner_var; // because inner_var is immutable, create mutable copy
        while (inner_var_mut < 3) {
            inner_var_mut = inner_var_mut + 1;
        }; // semicolon added here
        // inner_var should be 3
        assert!(inner_var_mut == 3, 1001);
    }

    // Test function to check variable updates across multiple loops
    // test]
    public fun test_variable_updates() {
        let counter: u64 = 0;
        let limit: u64 = 3;

        for (i in 0..limit) {
            counter = counter + i;
        }; // semicolon added here

        // counter = 0 + 0 + 1 + 2 = 3
        assert!(counter == 3, 1002);

        let val: u64 = 10;
        while (val > 0) {
            val = val - 1;
        }; // semicolon added here
        assert!(val == 0, 1003);
    }

    // Test access restrictions: external cannot call internal functions
    // test]
    public fun test_access_restrictions() {
        let s = &mut PrivateStruct { value: 5 };
        // Can call internal functions within module:
        internal_increment(s);
        assert!(*s.value == 6, 1004);

        // External code cannot call internal_increment from outside
        // The following line would be invalid outside the module:
        // external call: `0xCAFE::InteractionTests::internal_increment` (should fail if attempted outside)
    }

    // Test mutably referencing a resource and modifying it
    // test]
    public fun test_modify_via_reference(signer_addr: address) {
        let s: signer = signer::borrow_signer(signer_addr);
        move_to<PrivateStruct>(&s, PrivateStruct { value: 10 });
        let s_ref: &mut PrivateStruct = borrow_global_mut<PrivateStruct>(signer_addr);
        modify_value_ref(s_ref, 5);
        assert!((*s_ref).value == 15, 1005);
    }

    // Test immutably referencing a resource
    // test]
    public fun test_read_via_reference(signer_addr: address) {
        let s: signer = signer::borrow_signer(signer_addr);
        let _s_ref: &PrivateStruct = borrow_global<PrivateStruct>(signer_addr);
        // To get the value, we borrow the resource directly
        let s_global = borrow_global<PrivateStruct>(signer_addr);
        let val = read_value_ref(&s_global.value);
        // The value should be 10 before modification
        assert!(val == 10, 1006);
    }

    // Test that shadowed variables do not interfere with outer variables
    // test]
    public fun shadowed_variables_test() {
        let x: u64 = 100;

        if (true) {
            let x: u64 = 50; // shadowed
            assert!(x == 50, 1007);
        }

        // Outer x remains unchanged
        assert!(x == 100, 1008);
    }

    // Internal function to verify that mutable references work as intended
    fun internal_modify(s: &mut u64, delta: u64) {
        *s = *s + delta;
    }

    // Test internal modification function indirectly
    // test]
    public fun test_internal_modify() {
        let value: u64 = 20;
        internal_modify(&mut value, 10);
        assert!(value == 30, 1009);
    }

    // Function to test passing references to functions
    public fun pass_references_test() {
        let val: u64 = 7;
        modify_value_ref(&mut val, 3);
        assert!(val == 10, 1010);
        let read_val = read_value_ref(&val);
        assert!(read_val == 10, 1011);
    }

    // Run wrapper to call all internal tests
    public fun run_all_tests() {
        run_internal_tests();
        variable_shadowing_and_loops_test();
        test_variable_updates();
        test_access_restrictions();
        // For reference tests, instantiate some account addresses
        let addr1: address = @0xABCD;
        test_modify_via_reference(addr1);
        test_read_via_reference(addr1);
        shadowed_variables_test();
        // internal_modify is used with a mutable variable declared inside, so create one
        let val = 42;
        internal_modify(&mut val, 1);
        test_internal_modify();
        pass_references_test();
    }
}
