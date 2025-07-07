
//# publish
module 0xCAFE::LiveVariablesTest {
    use std::vector;
    use std::signer;

    // Test struct with abilities as postfix
    struct AbilityStruct has copy, drop, store, key { value: u64 }

    // Test enum with abilities
    enum AbilityEnum has copy, drop {
        Variant1,
        Variant2(u8),
        Variant3 { flag: bool }
    }

    // Declare a friend module - ensure addresses match
    // The module address must be 0xCAFE to match this module's address
    friend 0xCAFE::FriendModule;

    // Function to test variable analysis: declare various variables
    public fun test_live_variables(s: signer) {
        let _ = 10u64;
        let a = 20u64;
        let b = 30u64;
        let c = a + b;
        let d = c * 2;
        let e = d - 5;
        // Use variables to avoid removal
        let _ = e;

        // Declare and manipulate vector
        let vec: vector<u8> = vector::empty();
        vector::push_back(&mut vec, 1);
        vector::push_back(&mut vec, 2);
        vector::push_back(&mut vec, 3);
        let _ = vector::borrow(&vec, 0);
        let _ = vector::pop_back(&mut vec);

        // Explain -- Use variables after operations
        let _ = a;
        let _ = b;
        let _ = c;
        let _ = d;
        let _ = e;
    }

    // Function to test ability struct
    public fun create_ability_struct(x: u64): AbilityStruct {
        AbilityStruct { value: x }
    }

    // Function to test enum with abilities
    public fun create_ability_enum(choice: u8): AbilityEnum {
        if (choice == 0) {
            AbilityEnum::Variant1
        } else if (choice == 1) {
            AbilityEnum::Variant2(5)
        } else {
            AbilityEnum::Variant3 { flag: true }
        }
    }

    // Function to test friend declaration: call a friend function
    public fun call_friend_module(s: signer) {
        // Call function from friend module
        0xCAFE::FriendModule::friend_function(s);
    }

    // Wrapper function to run test_live_variables
    public fun run_live_variables_test() {
        let _s = signer::borrow_for_test();
        test_live_variables(_s)
    }

    // Wrapper function to run create_ability_struct
    public fun run_create_ability_struct(x: u64) {
        create_ability_struct(x)
    }

    // Wrapper function to run create_ability_enum
    public fun run_create_ability_enum(choice: u8) {
        create_ability_enum(choice)
    }

    // Wrapper function for friend call
    public fun run_call_friend(s: signer) {
        call_friend_module(s)
    }
}



//# run 0xCAFE::LiveVariablesTest::run_live_variables_test


//# run 0xCAFE::LiveVariablesTest::run_create_ability_struct --args 42


//# run 0xCAFE::LiveVariablesTest::run_create_ability_enum --args 2


//# run 0xCAFE::LiveVariablesTest::run_call_friend --signers 0xBADD
