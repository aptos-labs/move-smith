
//# publish
module 0xCAFE::AdditionModule {
    public fun add_and_return_fixed(a: u8, b: u8): u8 {
        let _sum = a + b;
        // ignore sum, always return 42
        42u8
    }

    public fun get_adder(): |u8, u8| u8 has copy+drop {
        let lambda = |x: u8, y: u8| {
            x + y
        };
        lambda
    }
}



//# run 0xCAFE::AdditionModule::add_and_return_fixed --args 10u8 15u8



//# run 0xCAFE::AdditionModule::get_adder



//# publish
module 0xCAFE::NestedCaller {
    use 0xCAFE::AdditionModule;

    public inline fun inline_add(x: u8, y: u8): u8 {
        x + y
    }

    public fun call_inline_add_and_lambda(x: u8, y: u8): u8 {
        let inline_sum = inline_add(x, y);
        let adder = AdditionModule::get_adder();
        let lambda_sum = adder(x, y);
        inline_sum + lambda_sum
    }
}



//# run 0xCAFE::NestedCaller::call_inline_add_and_lambda --args 3u8 4u8



//# publish
module 0xCAFE::UnusedChecker {
    // Function with unused variable and parameter
    public fun unused_var_and_param(_unused_param: u8): u8 {
        let _unused_var = 0u8;
        7u8
    }

    // Function with all parameters used - ensure no warnings on used params
    public fun used_params(a: u8, b: u8): u8 {
        a + b
    }
}



//# run 0xCAFE::UnusedChecker::unused_var_and_param --args 10u8



//# run 0xCAFE::UnusedChecker::used_params --args 5u8 6u8



//# publish
module 0xCAFE::KeyDropGeneric {
    // Removed unused import 'signer'
    // use std::signer;

    // Struct with key and drop abilities
    struct KDKeyDrop has key, drop {
        id: u64,
    }

    // A generic function requiring T: key + drop
    // Restriction: borrow_global and move_from can only be called on structs declared in current module.
    // So we can't use generic parameter T here.
    public fun borrow_and_move(addr: address) {
        let resource_ref = borrow_global<KDKeyDrop>(addr);
        let _id = 0u64;
        let _ = _id;

        let _moved = move_from<KDKeyDrop>(addr);
    }

    // Function to create and store KDKeyDrop at signer's address
    public fun create_and_store(s: signer) {
        let resource = KDKeyDrop { id: 123 };
        move_to<KDKeyDrop>(&s, resource);
    }
}



//# run 0xCAFE::KeyDropGeneric::create_and_store --signers 0xDEAD



//# run 0xCAFE::KeyDropGeneric::borrow_and_move --args 0xDEAD
