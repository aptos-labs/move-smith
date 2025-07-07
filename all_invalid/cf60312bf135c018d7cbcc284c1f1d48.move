// # publish
module 0xCAFE::SpecTest {
    use std::vector;

    // A simple struct with key, store and copy abilities
    struct Data has key, store, copy {
        val: u64,
        flag: bool
    }

    /// Simple function to test spec block
    public fun add_values(x: u64, y: u64): u64 {
        spec {
            ensures result == x + y;
        }
        x + y
    }

    /// Spec block including modifies and ensures
    public fun store_value(account: &signer, val: u64) {
        spec {
            modifies 0xCAFE::SpecTest::Data;
            ensures exists<Data>(@account);
            ensures borrow_global<Data>(@account).val == val;
        }
        move_to(account, Data { val, flag: true });
    }

    /// A "runner" function that exercises above functions for run command
    public fun run_no_arg() {
        let x = add_values(10, 32);
        let val = 1234;
        let addr = @0xCAFE;
        // simulate a signer - for testing we do not use signer here, just move_to used on 0xCAFE address
        // Note: signer needed for real move_to, but in testing environment 0xCAFE can be signer too
        move_to(&signer::borrow(&signer::address_to_signer(addr)), Data { val: val, flag: false });
        let data_ref = borrow_global<Data>(addr);
        let _ignore = data_ref.flag;
    }
}
// # run 0xCAFE::SpecTest::run_no_arg --signers 0xCAFE


//# publish
module 0xCAFE::VectorErrorTest {
    use std::vector;

    struct VStore has key, store {
        v: vector<u64>,
    }

    /// Push values inside vector, then intentionally cause an out-of-range panic
    public fun cause_vector_error() {
        let addr = @0xCAFE;
        let v = vector::empty<u64>();
        let v = vector::push_back(v, 10);
        let v = vector::push_back(v, 20);
        let store = VStore { v };
        move_to(&signer::borrow(&signer::address_to_signer(addr)), store);
        // Try to borrow out-of-bounds index (index 5 in 2 element vector)
        let store_ref = borrow_global_mut<VStore>(addr);
        let val = *vector::borrow(&store_ref.v, 5);
        // Use val to prevent "unused variable" warning
        let _ = val;
    }
}
//# run 0xCAFE::VectorErrorTest::cause_vector_error --signers 0xCAFE
#[expected_failure(vector_out_of_bounds)]


//# publish
module 0xCAFE::SaveModules {
    use std::debug;
    use std::vector;

    /// A function that "saves" compiled data, simulation only by emitting events/logs
    public fun save_module_to_disk() {
        // We do not have real filesystem access in Move, but we simulate by logging some bytes
        let dummy_binary = b"CAFEBABEDEADBEEF0123456789ABCDEF";
        debug::print(&dummy_binary);
    }
}
//# run 0xCAFE::SaveModules::save_module_to_disk --signers 0xCAFE

// Featurres:
// 6d0be2c02eeb777440500277409d24ee: Define specification blocks for Move modules.
// 438a5a28c4b3a3d65c2b6eb8f4ca3992: Indicate a vector operation error expected in your test with `#[expected_failure(vector_error)]` attribute, with optional minor status code.
// e4c0df198ad7e24642cbc634f79a4c48: Save compiled Move modules to disk as binary files.
