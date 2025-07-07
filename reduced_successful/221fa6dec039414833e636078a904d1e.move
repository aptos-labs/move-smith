
//# publish
module 0xCAFE::Addition {
    // This module tests addition and lambda expressions

    public fun add_and_return_sum(a: u8, b: u8): u8 {
        let sum = a + b;
        if (sum > 20) {
            20
        } else {
            sum
        }
    }

    public fun apply_lambda(a: u8, b: u8): u8 {
        // A lambda that adds two u8 numbers
        let add_lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| { x + y };
        add_lambda(a, b)
    }

    public fun use_nested_inline(x: u16): u16 {
        let (a, b) = (x, x); // Replaced missing MyModule::f2(x) call with dummy tuple for testing
        a + b
    }
}



//# run 0xCAFE::Addition::add_and_return_sum --args 10u8 15u8



//# run 0xCAFE::Addition::apply_lambda --args 7u8 8u8



//# run 0xCAFE::Addition::use_nested_inline --args 12u16



//# publish
module 0xCAFE::WildcardResourceTest {
    use std::signer;

    struct AnyResource has key, store { val: u8 }

    public fun store_any_resource(s: &signer, val: u8) {
        let obj = AnyResource { val };
        move_to<AnyResource>(s, obj);
    }

    public fun read_any_resource(addr: address): u8 acquires AnyResource {
        let val_ref = borrow_global<AnyResource>(addr);
        val_ref.val
    }

    public fun remove_any_resource(s: &signer) acquires AnyResource {
        let r = move_from<AnyResource>(signer::address_of(s));
        let AnyResource { val: _val } = r;
    }

    public fun do_store_read_remove(s: &signer, val: u8): u8 {
        store_any_resource(s, val);
        let v = read_any_resource(signer::address_of(s));
        remove_any_resource(s);
        v
    }
}



//# run 0xCAFE::WildcardResourceTest::do_store_read_remove --signers 0xDEAD --args 42u8
