// # publish
//# publish
module 0xCAFE::PoisonMod {
    use std::debug;

    // test_only]
    // cfg(feature = "unit_test")]
    public fun poison_test_only_1(): bool {
        debug::print(&b"PoisonMod::poison_test_only_1 called"[0..28]);
        true
    }

    // test_only]
    // cfg(feature = "unit_test")]
    public fun poison_test_only_2(x: u8): u8 {
        debug::print(&b"PoisonMod::poison_test_only_2 called"[0..28]);
        x + 42
    }

    public fun normal_func(): u8 {
        7u8
    }
}


// # run 0xCAFE::PoisonMod::normal_func


// # publish
//# publish
module 0xCAFE::CrossCaller {
    use 0xCAFE::PoisonMod;
    use std::debug;

    struct Data has store, key {
        val: u8,
    }

    public fun publish_data(s: &signer, val: u8) {
        let d = Data { val };
        move_to<Data>(s, d);
    }

    public fun read_data(addr: address): u8 acquires Data {
        let d_ref = borrow_global<Data>(addr);
        d_ref.val
    }

    public fun call_poison_and_loops(): u8 {
        let base = PoisonMod::normal_func();

        // cfg(feature = "unit_test")]
        let poison_result = PoisonMod::poison_test_only_2(10u8);

        let counter = 0u8;
        'outer: while (counter < 3) {
            let inner = 0u8;
            'inner: while (inner < 5) {
                if (inner == 2) {
                    inner = inner + 1;
                    continue 'inner;
                };
                if (counter == 2 && inner == 3) {
                    break 'outer;
                };
                counter = counter + 1;
                inner = inner + 1;
            };
        };

        base + counter
    }
}


// # run 0xCAFE::CrossCaller::call_poison_and_loops


// # publish
//# publish
module 0xCAFE::Integrator {
    use 0xCAFE::PoisonMod;
    use 0xCAFE::CrossCaller;
    use std::debug;
    use std::vector;

    // test_only]
    // cfg(feature = "unit_test")]
    public fun call_all_test_only_functions(): bool {
        debug::print(&b"Integrator::call_all_test_only_functions start"[0..40]);

        let v1 = PoisonMod::poison_test_only_1();
        debug::print(&b"Got PoisonMod::poison_test_only_1 result:"[0..35]);
        debug::print(&vector::from_u8(v1 as u8));

        let v2 = PoisonMod::poison_test_only_2(99u8);
        debug::print(&b"Got PoisonMod::poison_test_only_2 result:"[0..35]);
        debug::print(&vector::from_u8(v2));

        debug::print(&b"Integrator::call_all_test_only_functions end"[0..38]);
        true
    }

    public fun run_full_integration(addr: &signer): u8 acquires CrossCaller::Data {
        CrossCaller::publish_data(addr, 10u8);
        let val_before = CrossCaller::read_data(signer::address_of(addr));
        let call_res = CrossCaller::call_poison_and_loops();

        val_before + call_res
    }
}


// # run 0xCAFE::Integrator::run_full_integration --signers 0xDEAD


// # run 0xCAFE::Integrator::call_all_test_only_functions
