
//# publish
module 0xCAFE::TestModule {
    use std::signer;
    use std::vector;

    
        // This function calls other module functions to test invocation from script
        0xCAFE::TestModule::test_variable_scoping();
        0xCAFE::TestModule::test_access_control();
        0xCAFE::TestModule::test_storage_members();
    }

    
//# run 0xCAFE::TestModule::entry_point_invoke_module --signers 0xBADD

    // Function to test variable creation, shadowing, and scope within loops
    public fun test_variable_scoping() {
        // Outside while loop: variable x
        let x = 0u64;

        // Outer while loop
        while (x < 3) {
            // Shadowed variable x inside inner scope
            let x = x as u64 + 10;
            // Inside inner scope: local variable x shadowing outer
            let inner_x = x;
            // After inner block: updating x in outer scope
            x = x + 1;
        };

        // For loop with local variable
        let i = 0u8;
        while (i < 2) {
            let i = i + 1; // shadowing local variable
            i = i + 1; // update outer i
            i = i; // prevent unused variable warning
        };

        // At the end, assign to a final variable to check
        let final_x = x;
        // Use final_x to prevent unused variable warning
        final_x
    }

    // Function to test variable shadowing and scope with nested shadowing
    public fun test_shadowing() {
        let a = 5u8;
        let a = 10u8; // shadow outer a
        {
            let a = 20u8; // inner shadowing
            // use inner a
            let _ = a;
        };
        // Outer a should still be 10
        let _ = a;
    }

    // Internal function: can only be called within this module
    internal fun internal_function() {
        // simple no-op
    }

    // Function trying to access internal function from outside (should cause compile error if attempted)
    public fun test_access_control() {
        // Cannot access internal_function from outside, so comment out
        // internal_function(); // *This line should cause compile error if uncommented*
        ()
    }

    // Function to store and retrieve a non-deprecated member variable
    struct Person has store, key {
        name: vector<u8>,
        age: u8,
        // member not deprecated
    }

    public fun store_person(s: signer, name: vector<u8>, age: u8) {
        let person = Person {name, age};
        move_to<Person>(&s, person);
    }

    public fun get_person(s: signer): Person {
        borrow_global<Person>(signer::address_of(&s))
    }

    // Test entry point to exercise the above
    public fun run_all_tests(s: signer) {
        store_person(s, b"Alex", 30);
        let _ = get_person(s);
        test_variable_scoping();
        test_shadowing();
        test_access_control();
        ()
    }
}


//# run 0xCAFE::TestModule::run_all_tests --signers 0xDEAD


// Featurres:
// b70ccb6e356eebb5b3735f5f76cd5273: Write script entry points in Move modules
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
// 8a5b2df8cb7bc9368d7c39da6988075f: Store module member information without marking them as deprecated.
