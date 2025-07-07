
//# publish
module 0xCAFE::Adder {
    // Module to test addition and lambdas

    public fun add_two_values(a: u8, b: u8): u8 {
        a + b
    }

    public fun add_with_lambda(a: u8, b: u8): u8 {
        let sum_lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        sum_lambda(a, b)
    }

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }
}




//# publish
module 0xCAFE::Caller {
    use 0xCAFE::Adder;

    public fun call_inline_add(a: u8, b: u8): u8 {
        let c = Adder::inline_add(a, b);
        c
    }
}




//# publish
module 0xCAFE::ResourceUser {
    use std::signer;
    use std::vector;

    struct Res has key, store {
        values: vector<u8>
    }

    public fun init(s: signer) {
        let res = Res {
            values: vector[10u8, 20u8, 30u8]
        };
        move_to<Res>(&s, res);
    }

    public fun get_indexed_value(s: signer, idx: u64): u8 acquires Res {
        let res_ref = borrow_global<Res>(signer::address_of(&s));
        *vector::borrow(&res_ref.values, idx)
    }
}




//# run 0xCAFE::Adder::add_two_values --args 12u8 30u8




//# run 0xCAFE::Adder::add_with_lambda --args 15u8 25u8




//# run 0xCAFE::Caller::call_inline_add --args 20u8 22u8




//# run 0xCAFE::ResourceUser::init --signers 0xB001




//# run 0xCAFE::ResourceUser::get_indexed_value --signers 0xB001 --args 1u64




//# run 0xCAFE::ResourceUser::get_indexed_value --signers 0xB001 --args 2u64
