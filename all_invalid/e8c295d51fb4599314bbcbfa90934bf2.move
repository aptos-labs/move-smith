
//# publish
module 0xDEADBEEF::TestModule {
    use std::signer;
    use std::vector;

    // Struct with multiple fields for iteration test
    struct MultiFieldStruct has copy, drop {
        field1: u8,
        field2: u16,
        field3: u32,
        field4: bool,
    }

    // Resource to test access restrictions
    struct RestrictedAccess { value: u64 }

    public fun init_resource(s: signer, val: u64) {
        move_to<RestrictedAccess>(&s, RestrictedAccess { value: val });
    }

    // Get resource value
    public fun get_resource(s: signer): u64 {
        let r_ref: &RestrictedAccess = borrow_global<RestrictedAccess>(signer::address_of(&s));
        r_ref.value
    }

    // Internal function: access modifier restricts scope within module
    fun internal_fn() {
        // Just a marker function for testing internal visibility
    }

    // Entry function to test local variables and shadowing in while loop
    public fun test_variable_scoping() {
        let outer_var = 0u64;
        let counter = 0u64;

        // Variable to test shadowing inside while
        let shadow_var = 100u64;

        while(counter < 5) {
            let inner_counter = counter;
            let shadow_var = inner_counter + 200; // shadow inside loop
            assert!(shadow_var >= 200 && shadow_var < 205, 1234);
            counter = inner_counter + 1;
        };

        // Check that outer variable remains unchanged
        assert!(outer_var == 0, 5678);
        // Confirm counter is 5 after loop
        assert!(counter == 5, 91011);
    }

    // Entry function to test iteration over struct fields
    public fun test_struct_iteration() {
        let s = MultiFieldStruct {
            field1: 1,
            field2: 2,
            field3: 3,
            field4: true,
        };
        // Check individual fields
        if (s.field1 == 1) {
            // do nothing
        } else {
            assert!(false, 4444);
        };
        if (s.field2 == 2) {
            // do nothing
        } else {
            assert!(false, 5555);
        };
        if (s.field3 == 3) {
            // do nothing
        } else {
            assert!(false, 6666);
        };
        if (s.field4) {
            // do nothing
        } else {
            assert!(false, 7777);
        };
    }

    // Wrapper function to run variable scoping test
    public fun run_variable_scoping() {
        test_variable_scoping();
    }

    // Wrapper function to run struct iteration test
    public fun run_struct_iteration() {
        test_struct_iteration();
    }
}


//# run 0xDEADBEEF::TestModule::run_variable_scoping


//# run 0xDEADBEEF::TestModule::run_struct_iteration


// Featurres:
// b70ccb6e356eebb5b3735f5f76cd5273: Write script entry points in Move modules
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
// 8904a4822b34c829900e121b1fdae630: Test that a `while` loop correctly counts from 0 to 5 and that the assertion passes when the loop terminates.
// bd28eeae1ce71d93da1b64be274d9e2f: Iterate over fields of a struct to handle each field individually.
