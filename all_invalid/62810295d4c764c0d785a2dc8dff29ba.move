
//# publish
module 0xCAFE::Adder {
    // Module to test addition of two u8 values and lambda use

    // A struct tagged with abilities
    struct Data has copy, drop {
        value: u8
    }

    public fun add_two_values(x: u8, y: u8): u8 {
        let sum = x + y;
        sum
    }

    public fun add_lambda(x: u8, y: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        lambda(x, y)
    }

    public fun run_no_args(): u8 {
        add_two_values(1u8, 2u8)
    }
}



//# run 0xCAFE::Adder::add_two_values --args 10u8 20u8



//# run 0xCAFE::Adder::add_lambda --args 11u8 22u8



//# run 0xCAFE::Adder::run_no_args




//# publish
module 0xCAFE::NestedCalls {
    use 0xCAFE::Adder;

    // Struct with abilities
    struct Container has store {
        label: vector<u8>,
        data: u8,
    }

    public fun call_inline_and_add(x: u8, y: u8): u8 {
        let partial_sum = Adder::add_two_values(x, y);
        // Replaced ternary operator with if/else statement because Move does not support '? :'
        let (a, b) = if Adder::add_two_values(x, y) == partial_sum {
            (x + 1, y + 1)
        } else {
            (0, 0)
        };

        // Return sum of a and b plus partial_sum for test purposes
        a + b + partial_sum
    }

    public fun runner(): u8 {
        call_inline_and_add(5u8, 10u8)
    }
}



//# run 0xCAFE::NestedCalls::call_inline_and_add --args 7u8 8u8



//# run 0xCAFE::NestedCalls::runner




//# publish
module 0xCAFE::ErrorMessages {
    // Module to test detailed error messages in bytecode verification

    struct WithKey has key {
        id: u64
    }

    public fun cause_error() {
        // Should error if we try to move_from at non-existent address
        // (Here for test, fetch does not find resource and triggers error)
        // It's expected to raise error in VM about resource not found or such

        // We use an address unlikely to have resource, so inner errors can be triggered
        let r = move_from<WithKey>(@0xDEADBEEF);
        // Consume r by unpacking so it doesn't implicitly drop
        let WithKey { id: _ } = r;
    }
}



//# run 0xCAFE::ErrorMessages::cause_error




//# publish
module 0xCAFE::AbleTypes {
    // Testing abilities annotation

    struct CopyDropOnly has copy, drop {
        a: u8,
        b: u8
    }

    struct StoreKeyOnly has store, key {
        id: u64,
        flag: bool
    }

    public fun create_copydrop(): CopyDropOnly {
        CopyDropOnly {a: 1u8, b: 2u8}
    }

    public fun create_storekey(): StoreKeyOnly {
        StoreKeyOnly {id: 42u64, flag: true}
    }

    public fun use_abilities() {
        let cd = create_copydrop();
        let _cd2 = copy cd;
        let sk = create_storekey();
        // To avoid implicit drop error for sk which has no drop ability,
        // consume sk by unpacking
        let StoreKeyOnly { id: _, flag: _ } = sk;
        // We don't do move operations here, just function calls
    }
}



//# run 0xCAFE::AbleTypes::create_copydrop



//# run 0xCAFE::AbleTypes::create_storekey



//# run 0xCAFE::AbleTypes::use_abilities




//# publish
module 0xCAFE::AddressLiterals {
    use std::signer;

    // Uses explicit address literals in code

    struct StoredAddress has key, store {
        owner: address,
        value: u64
    }

    public fun store_value(addr: address, val: u64) {
        let obj = StoredAddress {owner: addr, value: val};
        move_to<StoredAddress>(&signer::borrow_signer(addr), obj);
    }

    public fun get_stored_value(addr: address): u64 acquires StoredAddress {
        let obj_ref = borrow_global<StoredAddress>(addr);
        obj_ref.value
    }

    public fun runner(): u64 {
        let addr = @0xCAFE;
        let val = 12345u64;
        // Only try to store if signer is addr in real transaction
        val
    }
}



//# run 0xCAFE::AddressLiterals::runner
