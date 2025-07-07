
//# publish
module 0xCAFE::LoopAndStorage {
    use std::signer;

    struct Accumulator has store, key {
        sum: u64,
        count: u64,
        stored_func: StoreFunc,
    }

    // A public, store-compatible struct to store a function pointer
    // Fixed syntax for function type in struct field declaration: 
    // 'fn(u64, u64): u64' is invalid in Move, use 'fn(u64, u64) -> u64' instead.
    struct StoreFunc has copy, drop, store {
        f: fn(u64, u64) -> u64,
    }

    public fun add(a: u64, b: u64): u64 {
        a + b
    }

    public fun new_accumulator_with_func(f: fn(u64, u64) -> u64): Accumulator {
        Accumulator { sum: 0, count: 0, stored_func: StoreFunc { f } }
    }

    public fun accumulate_loop(n: u64): u64 {
        let sum = 0;
        let i = 0;
        while (i < n) {
            sum = sum + i;
            i = i + 1;
        };
        sum
    }

    public fun store_accumulator(s: signer, acc: Accumulator) {
        move_to<Accumulator>(&s, acc);
    }

    public fun use_accumulator(s: signer, val: u64): u64 {
        let acc_ref = borrow_global_mut<Accumulator>(signer::address_of(&s));
        let f_inst = acc_ref.stored_func.f;
        acc_ref.sum = f_inst(acc_ref.sum, val);
        acc_ref.count = acc_ref.count + 1;
        acc_ref.sum
    }

    public fun move_accumulator(s: signer): Accumulator {
        move_from<Accumulator>(signer::address_of(&s))
    }

    public fun call_stored_func_directly(val1: u64, val2: u64): u64 {
        add(val1, val2)
    }
}



//# run 0xCAFE::LoopAndStorage::accumulate_loop --args 10u64



//# run 0xCAFE::LoopAndStorage::call_stored_func_directly --args 15u64 27u64



//# run 0xCAFE::LoopAndStorage::store_accumulator --signers 0xDEAD --args


//# run 0xCAFE::LoopAndStorage::use_accumulator --signers 0xDEAD --args 5u64


//# run 0xCAFE::LoopAndStorage::use_accumulator --signers 0xDEAD --args 10u64


//# run 0xCAFE::LoopAndStorage::move_accumulator --signers 0xDEAD




//# publish
module 0xCAFE::GlobalResourceTester {
    use std::signer;
    // These imports are unused, you can remove them or prefix with underscore to avoid warning.
    //use std::option;
    //use std::error;

    struct DummyResource has store, key {
        value: u64,
    }

    public fun create_resource(s: signer, val: u64) {
        let dummy = DummyResource { value: val };
        move_to<DummyResource>(&s, dummy);
    }

    public fun borrow_resource_with_valid_address(_s: signer, addr: address): u64 acquires DummyResource {
        let dummy_ref = borrow_global<DummyResource>(addr);
        dummy_ref.value
    }

    public fun borrow_resource_with_invalid_address(addr: address): u64 acquires DummyResource {
        // This will fail if addr does not have the resource
        let dummy_ref = borrow_global<DummyResource>(addr);
        dummy_ref.value
    }

    public fun try_borrow_and_handle(addr: address): u64 acquires DummyResource {
        if (exists<DummyResource>(addr)) {
            let dummy_ref = borrow_global<DummyResource>(addr);
            dummy_ref.value
        } else {
            0
        }
    }
}



//# run 0xCAFE::GlobalResourceTester::create_resource --signers 0xF00D --args 42u64



//# run 0xCAFE::GlobalResourceTester::borrow_resource_with_valid_address --signers 0xF00D --args 0xF00D



//# run 0xCAFE::GlobalResourceTester::try_borrow_and_handle --args 0xBEEF



//# run 0xCAFE::GlobalResourceTester::borrow_resource_with_invalid_address --args 0xBEEF
