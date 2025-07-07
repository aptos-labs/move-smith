
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


//# run 0xCAFE::PoisonMod::normal_func



//# publish
module 0xCAFE::CrossCaller {
    use 0xCAFE::PoisonMod;
    use std::debug;

    // A struct with key, to test cross-module publishing
    struct Data has store, key {
        val: u8,
    }

    // Publish a resource, to test access
    public fun publish_data(s: &signer, val: u8) {
        let d = Data { val };
        move_to<Data>(s, d);
    }

    public fun read_data(addr: address): u8 acquires Data {
        let d_ref = borrow_global<Data>(addr);
        d_ref.val
    }

    public fun call_poison_and_loops(): u8 {
        // Call PoisonMod's normal func
        let base = PoisonMod::normal_func();

        // The test-only poison function should not be callable here directly.
        // But we call it with conditional compilation
        // cfg(feature = "unit_test")]
        let poison_result = PoisonMod::poison_test_only_2(10u8);

        let counter = 0u8;
        'outer: while counter < 3 {
            let inner = 0u8;
            'inner: while inner < 5 {
                if inner == 2 {
                    inner = inner + 1;
                    continue 'inner;
                };
                if counter == 2 && inner == 3 {
                    break 'outer;
                };
                counter = counter + 1;
                inner = inner + 1;
            };
        };

        // Return sum of base and counter
        base + counter
    }
}


//# run 0xCAFE::CrossCaller::call_poison_and_loops



//# publish
module 0xCAFE::Integrator {
    use 0xCAFE::PoisonMod;
    use 0xCAFE::CrossCaller;
    use std::debug;

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


//# run 0xCAFE::Integrator::run_full_integration --signers 0xDEAD


//# run 0xCAFE::Integrator::call_all_test_only_functions


// Featurres:
// 64ac167c2f2c35ec915331e64fbb6833: Create test-only poison functions that depend on the 'unit_test' VM feature to prevent accidental deployment of test-compiled modules.
// f6672aaafc5c8676afcf660bcf2aada6: Test that modules can successfully define, publish, and call functions and structs across dependencies, ensuring correct interaction and access between modules.
// f6d1ca79b74d335b0452db46cd62a0fa: Break and continue from labeled loops using `break` and `continue`.
