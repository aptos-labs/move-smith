
//# publish
module 0xCAFE::LambdaAdder {
    // Imports using member imports
    use 0xCAFE::MyModule::{f2, StructWithTypeParameter, MODULE_MAGIC};

    // Declare friend module for LambdaFriend
    friend 0xCAFE::LambdaFriend;

    // Private function only callable by friend modules
    fun private_add(x: u8, y: u8): u8 {
        x + y
    }

    // Public function that returns a lambda (anonymous function) that adds two u8 values and returns u8
    public fun get_adder_lambda(): |u8, u8| u8 {
        |a: u8, b: u8| { a + b }
    }

    // Public function which calls inline function f2 from MyModule and does nested call
    public fun nested_inline_call(a: u16): u16 {
        let (v1, v2) = f2(a);
        v1 + v2
    }

    // Public function that calls the private function via friend module should be tested from friend module only
    public fun call_private_add(x: u8, y: u8): u8 {
        private_add(x, y)
    }

    // Store some module members as resource (simulate store without deprecated)
    struct StoredInfo has store {
        magic: u32,
        value: u8,
    }

    public fun store_info(s: &signer, val: u8) {
        let info = StoredInfo { magic: MODULE_MAGIC, value: val };
        move_to<StoredInfo>(s, info);
    }

    public fun get_stored_value(addr: address): u8 {
        let info_ref = borrow_global<StoredInfo>(addr);
        info_ref.value
    }
}


//# publish
module 0xCAFE::LambdaFriend {
    use std::signer;
    use 0xCAFE::LambdaAdder;

    // Friend module can call private function in LambdaAdder
    public fun call_friend_private_add(x: u8, y: u8): u8 {
        LambdaAdder::private_add(x, y)
    }

    // A function that calls LambdaAdder public functions to test full flow
    public fun run_all_tests(s: signer) {
        // Test lambda adder
        let lambda = LambdaAdder::get_adder_lambda();
        let _sum = lambda(10u8, 20u8);

        // Test nested inline call
        let _nested_sum = LambdaAdder::nested_inline_call(5u16);

        // Test call private add from friend
        let _private_sum = LambdaAdder::private_add(3u8, 4u8);

        // Store info in account storage
        LambdaAdder::store_info(&s, 42u8);

        // Get stored value
        let _val = LambdaAdder::get_stored_value(signer::address_of(&s));
    }
}


//# run 0xCAFE::LambdaAdder::get_adder_lambda


//# run 0xCAFE::LambdaAdder::nested_inline_call --args 7u16


//# run 0xCAFE::LambdaAdder::call_private_add --args 6u8 8u8


//# run 0xCAFE::LambdaFriend::call_friend_private_add --args 9u8 1u8


//# run 0xCAFE::LambdaFriend::run_all_tests --signers 0xCAFE


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// e0f723b44afdc4c1f59c12350179c24a: Import all public functions, structs, and constants from another module using member imports in the 'use' statement.
// 8311136ddcd01f2389ebb54b0ddc4a3b: Declare friend relationships between Move modules so that only friend modules can call private functions
// 8a5b2df8cb7bc9368d7c39da6988075f: Store module member information without marking them as deprecated.
