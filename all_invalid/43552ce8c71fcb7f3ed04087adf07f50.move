
//# publish
module 0xDEAD::TestModule {
    use std::vector;

    // Entry function that calls other functions
    public entry fun call_entry_functions() {
        assert!(f_external(5u8) == 10u8, 100);
        assert!(f_with_local_vars(0u8) == 2u8, 101);
        assert!(test_access_control(10u8) == 20u8, 102);
        assert!(cross_module_call() == 42u64, 103);
    }

    // Function called by script, tests variable scoping with while loop
    public fun f_with_local_vars(start: u8): u8 {
        let val = start;
        let counter = 0u8;
        while (counter < 3u8) {
            let val = val + 1; // Shadowing local variable
            let counter = counter + 1;
        };
        // After loop, val should remain unchanged
        val
    }

    // Internal function with internal visibility
    fun internal secret() : u8 {
        42u8
    }

    // Access control test: internal function, called within the module
    public fun test_access_control(x: u8): u8 {
        let _ = secret(); // Valid within module
        x * 2
    }

    // Function with qualified name and different visibilities
    public(entry) fun public_script_fn(x: u8): u8 {
        x + 1
    }

    public(friend) fun friend_fn(x: u8): u8 {
        x + 2
    }

    // Internal function not accessible externally
    fun internal_fn(x: u8): u8 {
        x + 3
    }

    // Internal function to test cross-module restricted access (should not be callable outside)
    fun restricted_func(x: u8): u8 {
        x + 4
    }

    // Function to test cross-module call via fully qualified path
    public fun cross_module_call(): u64 {
        // Only access public or friend functions with proper qualification
        42u64
    }
}



//# run 0xDEAD::TestModule::call_entry_functions --signers 0x1111



//# publish
module 0xBADD::ExternalAccess {
    use 0xDEAD::TestModule;

    // Attempt to call internal function of TestModule (should NOT compile if uncommented)
    // public fun try_call_internal() {
    //     let _ = TestModule::secret(); // Should cause compile error due to internal visibility
    // }

    // Call the public(script) function
    public(entry) fun test_public_script() {
        let res = TestModule::public_script_fn(10u8);
        assert!(res == 11u8, 200);
    }

    // Call the friend function (allowed if friend)
    public(friend) fun test_friend_fn() {
        let res = TestModule::friend_fn(10u8);
        assert!(res == 12u8, 201);
    }

    // Attempt to call internal function directly (should not compile if external)
    // public fun attempt_internal_call() {
    //     let _ = TestModule::internal_fn(10u8); // Should cause compile error
    // }
}



//# run 0xBADD::ExternalAccess::test_public_script --signers 0x2222



//# run 0xBADD::ExternalAccess::test_friend_fn --signers 0x2222
