//# publish
module 0xCAFE::TestModule {
    // 1. Declare two different friend modules with unique names.
    friend 0xBABE::FriendA;
    friend 0x0000::FriendB;

    // 2. Attempt to declare a duplicate friend module with the same name to trigger compiler error.
    // This line should cause an error if uncommented.
    // friend 0xFACE::FriendA; // ERROR: duplicate friend declaration for 'FriendA'

    // 3. Use a reserved name 'SELF_NAME' to ensure compiler treats it as an identifier.
    // The identifier 'SELF_NAME' is reserved, so using it as a module or variable name should error.
    // Declaring a module named 'SELF_NAME' should error. We'll test it by trying a variable name.
    public fun reserved_name_test() {
        let SELF_NAME = 42; // Should be okay, but if used as a module name, it should error.
        // Alternatively, if we try to declare a module named 'SELF_NAME', it should error:
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

// Note: In this test setup, the key parts are:
// - Declaring multiple friends with unique modules (should compile)
// - Uncommenting the duplicate friend declaration to trigger an error
// - Using a reserved name 'SELF_NAME' as a variable (should be accepted as an identifier)
// - Using an undefined constant 'UNDEFINED_CONST' to trigger an unbound constant error during compilation

// Featurres:
// 89f057e367824cf777ca790ae5503f75: Ensure that each friend module declaration is unique within a module and get a compiler error if you declare the same friend module more than once.
// 1d77a63b6a1acc3e0bf1e0bc388ca635: Use reserved names for modules or aliases, such as 'SELF_NAME', to prevent their usage as identifiers.
// 078c83a4367d65e60be6f57a66576bb6: Detect and report unbound or undefined constants during compilation.
