
//# publish
module 0xCAFE::MyModule {
    public inline fun f2(a: u16): (u16, u16) {
        (a, a + 1)
    }
}


//# publish
module 0xCAFE::Calculator {
    // Removed unused use std::signer;

    public fun add_then_return_fixed(a: u8, b: u8): u8 {
        let sum = a + b;
        // Always return 42 to test computation before returning a fixed value
        42
    }

    public fun use_lambda(a: u8, b: u8): u8 {
        let adder: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        adder(a, b)
    }

    public inline fun inline_addition(a: u8, b: u8): u8 {
        a + b
    }

    public fun call_inline(a: u8, b: u8): u8 {
        inline_addition(a, b)
    }

    public fun call_other_module_inline(a: u16): u16 {
        // Now calls 0xCAFE::MyModule::f2 which exists and returns tuple (u16, u16)
        let (v1, v2) = 0xCAFE::MyModule::f2(a);
        v1 + v2
    }
}



//# run 0xCAFE::Calculator::add_then_return_fixed --args 10u8 15u8



//# run 0xCAFE::Calculator::use_lambda --args 7u8 8u8



//# run 0xCAFE::Calculator::call_inline --args 12u8 30u8



//# run 0xCAFE::Calculator::call_other_module_inline --args 100u16




//# publish
module 0xCAFE::User {
    use std::signer;
    use 0xCAFE::Calculator;

    struct UserData has key, store {
        id: u64,
        name: vector<u8>,
        score: u8,
    }

    public fun create_user(s: signer, id: u64, name: vector<u8>, score: u8) {
        let data = UserData {id, name, score};
        move_to<UserData>(&s, data);
    }

    public fun update_score(s: signer, increment: u8) {
        let user_ref: &mut UserData = borrow_global_mut<UserData>(signer::address_of(&s));
        // Use Calculator::use_lambda to add increment to existing score
        let new_score = Calculator::use_lambda(user_ref.score, increment);
        user_ref.score = new_score;
    }

    public fun get_score(s: signer): u8 {
        let user_ref: &UserData = borrow_global<UserData>(signer::address_of(&s));
        user_ref.score
    }
}



//# run 0xCAFE::User::create_user --signers 0xBEEF --args 123u64 b"Bob" 10u8



//# run 0xCAFE::User::get_score --signers 0xBEEF



//# run 0xCAFE::User::update_score --signers 0xBEEF --args 32u8



//# run 0xCAFE::User::get_score --signers 0xBEEF
