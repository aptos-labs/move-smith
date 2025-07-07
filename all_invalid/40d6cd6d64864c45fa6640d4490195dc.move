//# publish
module 0x1::SpecTest {
    use std::error;
    use std::signer;

    #[friend(0x1::SpecTest)]
    struct Data has copy, drop, store {
        a: u64,
        b: bool,
    }

    // This function exercises specification keywords such as requires, ensures, aborts, emits, modifies, decreases, assert, assume, succeeds_if
    // It emits an event and modifies a resource
    struct EventHolder has key {
        val: u64,
        dummy_event: Event<u64>,
    }

    resource struct Event<T> has key { val: T }

    // Holder resource for testing modifies and emits
    struct Holder has key {
        counter: u64,
    }

    #[friend(0x1::SpecTest)]
    struct CounterHasKey has key {}

    // Create a dummy event handle
    public fun create_event(holder: &signer) {
        move_to(holder, EventHolder {
            val: 100,
            dummy_event: Event<u64> { val: 10 },
        });
    }

    public fun create_holder(account: &signer) {
        move_to(account, Holder { counter: 0 });
    }

    // Runner function for tests without params or signers
    public fun runner() {
        // does nothing
    }

    #[spec]
    fun helper_spec(i: u64) {
        assert!(i < 10, 100);
        assume!(i >= 0);
    }

    // Function embedding many spec constructs
    public fun test_specs(account: &signer, x: u64, y: bool) acquires Holder {
        // requires
        require!(x > 0, error::invalid_argument(1));
        // assumes
        assume!(y == true);

        // modifies
        let holder = borrow_global_mut<Holder>(signer::address_of(account));
        modifies!({holder.counter});

        // emits
        // (for simulation purposes just update holder.counter)
        holder.counter = holder.counter + 1;

        // decreases: dummy loop with decreases spec
        let mut i = x;
        decreases!(i);
        while (i > 0) {
            i = i - 1;
        }

        // aborts with code 100 on some condition
        if (!y) {
            abort 100;
        }

        // abort with
        aborts_with!(100);

        // succeeds_if
        succeeds_if!(holder.counter > 0);

        // assert
        assert!(x > 0, 200);

        // ensures - post-condition: holder.counter increased by 1
        ensures!(borrow_global<Holder>(signer::address_of(account)).counter > 0);
    }
}
//# run 0x1::SpecTest::runner --signers 0x1

//# publish
module 0x1::PackTest {
    use std::signer;

    // A struct with multiple fields
    struct S has copy, drop, store {
        f1: u8,
        f2: u64,
        f3: bool,
    }

    public fun make_s(): S {
        // packing multiple values into the struct with Pack expression
        S { f1: 10, f2: 1000, f3: true }
    }

    public fun dummy() {}

    public fun runner() {
        let s = make_s();
        // Normally do something with s, but test just packs
        let _packed = s;
    }
}
//# run 0x1::PackTest::runner

//# publish
module 0x1::AttrTest {
    use std::vector;

    // Remove duplicate attributes from a vector of u8
    public fun remove_duplicates(mut attrs: vector<u8>): vector<u8> {
        let mut res = vector::empty<u8>();
        let len = vector::length(&attrs);
        let mut i = 0;
        while (i < len) {
            let mut found = false;
            let val = *vector::borrow(&attrs, i);
            let res_len = vector::length(&res);
            let mut j = 0;
            while (j < res_len) {
                if (*vector::borrow(&res, j) == val) {
                    found = true;
                    break;
                }
                j = j + 1;
            }
            if (!found) {
                vector::push_back(&mut res, val);
            }
            i = i + 1;
        }
        res
    }

    public fun test_remove_duplicates(): vector<u8> {
        let v = vector::from_bytes(b"\x01\x02\x02\x03\x03\x03\x04\x01");
        remove_duplicates(v)
    }
}
//# run 0x1::AttrTest::test_remove_duplicates