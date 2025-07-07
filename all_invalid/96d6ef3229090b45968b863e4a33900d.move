// This transactional test covers:
// 1. Constants of type u64 in modules.
// 2. Multiple increment and access patterns for primitives, structs, wrappers, and vectors.
// 3. Resource management, vector ops, borrowing, mutability, inter-module calls.

//# publish
module 0xCAFE::Constants {
    const BASE_VALUE: u64 = 1000;
    const INCREMENT: u64 = 7;

    public fun get_base(): u64 {
        BASE_VALUE
    }

    public fun get_increment(): u64 {
        INCREMENT
    }

    public inline fun add_constants(): u64 {
        BASE_VALUE + INCREMENT
    }

    public fun runner(): u64 {
        let s = get_base();
        let i = get_increment();
        s + i
    }
}
//# run 0xCAFE::Constants::runner


//# publish
module 0xCAFE::PrimitiveOps {
    // Increment implementations for u64 and u8
    public fun inc_u64_field(x: u64): u64 {
        x + 1
    }

    public inline fun inc_u8_field(x: u8): u8 {
        x + 1
    }

    public fun complex_inc_u64(x: u64): u64 {
        let y = inc_u64_field(x);
        let z = y + 10;
        z
    }

    public fun runner(): u64 {
        let a = 42u64;
        let b = inc_u64_field(a);
        let c = complex_inc_u64(a);
        b + c
    }
}
//# run 0xCAFE::PrimitiveOps::runner


//# publish
module 0xCAFE::StructOps {
    struct Counter has copy, drop, store {
        value: u64,
        small: u8,
    }

    public fun new_counter(val: u64, small: u8): Counter {
        Counter { value: val, small }
    }

    public inline fun inc_value(counter: Counter): Counter {
        Counter { value: counter.value + 1, small: counter.small }
    }

    public fun inc_small_ref(counter: &mut Counter) {
        counter.small = counter.small + 1;
    }

    public fun get_value(counter: &Counter): u64 {
        counter.value
    }

    public fun get_small(counter: &Counter): u8 {
        counter.small
    }

    public fun runner(): u64 {
        let c = new_counter(10, 5);
        let c2 = inc_value(c);
        let mut c3 = c2;
        inc_small_ref(&mut c3);
        get_value(&c3) + (get_small(&c3) as u64)
    }
}
//# run 0xCAFE::StructOps::runner


//# publish
module 0xCAFE::WrapperOps {
    struct Wrapper has copy, drop, store {
        inner: u64,
    }

    public fun wrap(val: u64): Wrapper {
        Wrapper { inner: val }
    }

    public fun inc_wrapper(w: Wrapper): Wrapper {
        Wrapper { inner: w.inner + 1 }
    }

    public fun unwrap(w: &Wrapper): u64 {
        w.inner
    }

    public fun runner(): u64 {
        let w = wrap(20);
        let w2 = inc_wrapper(w);
        unwrap(&w2)
    }
}
//# run 0xCAFE::WrapperOps::runner


//# publish
module 0xCAFE::VectorOps {
    use std::vector;

    public fun new_vector(): vector<u64> {
        vector::empty<u64>()
    }

    public fun push_val(v: &mut vector<u64>, val: u64) {
        vector::push_back<u64>(v, val);
    }

    public fun inc_all(v: &mut vector<u64>) {
        let len = vector::length<u64>(v);
        let mut i = 0u64;
        while (i < len) {
            let val_ref = vector::borrow_mut<u64>(v, i as usize);
            *val_ref = *val_ref + 1;
            i = i + 1;
        }
    }

    public fun sum_vec(v: &vector<u64>): u64 {
        let len = vector::length<u64>(v);
        let mut i = 0u64;
        let mut total = 0u64;
        while (i < len) {
            let val_ref = vector::borrow<u64>(v, i as usize);
            total = total + *val_ref;
            i = i + 1;
        }
        total
    }

    public fun runner(): u64 {
        let mut v = new_vector();
        push_val(&mut v, 1);
        push_val(&mut v, 2);
        push_val(&mut v, 3);
        inc_all(&mut v);
        sum_vec(&v)
    }
}
//# run 0xCAFE::VectorOps::runner


//# publish
module 0xCAFE::ResourceMgr {
    use std::signer;

    struct Store has key, store {
        counter: u64,
    }

    public fun init_store(account: &signer) {
        let addr = signer::address_of(account);
        if (!exists<Store>(addr)) {
            move_to<Store>(account, Store { counter: 0 });
        }
    }

    public fun inc_store(account: &signer) {
        let addr = signer::address_of(account);
        let store_ref = borrow_global_mut<Store>(addr);
        store_ref.counter = store_ref.counter + 1;
    }

    public fun read_store(account: &signer): u64 {
        let addr = signer::address_of(account);
        let store_ref = borrow_global<Store>(addr);
        store_ref.counter
    }

    public fun runner(account: &signer): u64 {
        init_store(account);
        inc_store(account);
        inc_store(account);
        read_store(account)
    }
}
//# run 0xCAFE::ResourceMgr::runner --signers 0xCAFE


//# publish
module 0xCAFE::CrossModule {
    use 0xCAFE::StructOps;
    use 0xCAFE::WrapperOps;

    public fun inc_struct_counter_val(counter: StructOps::Counter): u64 {
        let inc_counter = StructOps::inc_value(counter);
        StructOps::get_value(&inc_counter)
    }

    public fun inc_wrapper_val(wrapper: WrapperOps::Wrapper): u64 {
        let inc_wrapper = WrapperOps::inc_wrapper(wrapper);
        WrapperOps::unwrap(&inc_wrapper)
    }

    public fun runner(): u64 {
        let c = StructOps::new_counter(50, 20);
        let w = WrapperOps::wrap(30);
        let c_res = inc_struct_counter_val(c);
        let w_res = inc_wrapper_val(w);
        c_res + w_res
    }
}
//# run 0xCAFE::CrossModule::runner


//# run
script {
    use 0xCAFE::Constants;
    use 0xCAFE::PrimitiveOps;
    use 0xCAFE::StructOps;
    use 0xCAFE::WrapperOps;
    use 0xCAFE::VectorOps;
    use 0xCAFE::ResourceMgr;
    use 0xCAFE::CrossModule;

    fun main(account: signer) {
        // Test Constants
        let c1 = Constants::get_base();
        let c2 = Constants::get_increment();
        let c3 = Constants::add_constants();

        // PrimitiveOps
        let p = PrimitiveOps::runner();

        // StructOps interaction
        let s = StructOps::runner();

        // WrapperOps interaction
        let w = WrapperOps::runner();

        // VectorOps interaction
        let v = VectorOps::runner();

        // Resource Management
        ResourceMgr::init_store(&account);
        ResourceMgr::inc_store(&account);
        let r = ResourceMgr::read_store(&account);

        // Cross Module Interaction
        let x = CrossModule::runner();

        // Just receive all results to exercise values
        // No assertions needed for this transactional test
        let _ = (c1, c2, c3, p, s, w, v, r, x);
    }
}