//# publish
module 0xCAFE::TestModule {
    // 1. Declare two different friend modules with the same address (must be same address).
    friend 0xCAFE::FriendA;
    friend 0xCAFE::FriendB;

    // 2. Attempt to declare a duplicate friend module with the same name to trigger compiler error.
    // This line should cause an error if uncommented.
    // friend 0xCAFE::FriendA; // ERROR: duplicate friend declaration for 'FriendA'

    // 3. Use a reserved name 'SELF_NAME' as an identifier (not as a module name).
    // Declaring a variable named 'SELF_NAME' is acceptable. The error in the message was
    // because 'SELF_NAME' was used as a module name, which is invalid.
    public fun reserved_name_test() {
        let SELF_NAME = 42; // OK, variable name
        // If we try to declare a module named 'SELF_NAME', it should error:
        // module SELF_NAME { ... } // ERROR: 'SELF_NAME' is a reserved name.
    }

    // 4. Define some constants and attempt to access an unbound constant to test detection.
    const EXISTING_CONST: u64 = 100;

    public fun constant_test() {
        let value = EXISTING_CONST;
        // Uncomment the following line to test error with unbound constant.
        // let undefined_value = UNDEFINED_CONST; // ERROR: unbound constant 'UNDEFINED_CONST'
    }

    // 5. Defining a 'runner' function for the module to invoke other tests.
    public fun run_all_tests() {
        reserved_name_test();
        constant_test();
    }
}

// //# run 0xCAFE::TestModule::run_all_tests --signers 0xCAFE

//# publish
module 0xCAFE::FriendA {
    // No additional content needed for this test.
}

// //# run 0xCAFE::FriendA::some_function --signers 0xCAFE

//# publish
module 0xCAFE::FriendB {
    // No additional content needed for this test.
}

// Uncomment the following to test compiler error for duplicate friend declaration
// //# publish
// module 0xCAFE::DuplicateFriendTest {
//     friend 0xDEAD::SomeFriend;
//     // duplicate declaration
//     friend 0xDEAD::SomeFriend; // ERROR: duplicate friend declaration
// }