
//# publish
module 0xCAFE::SpecTest {
    use std::signer;

    struct St has copy, drop, store {
        val: u8,
    }

    // Test unbound imports: we deliberately import a nonexistent member to check compiler warnings (commented out to not fail compilation)
    // use 0xCAFE::NonexistentModule;
    // use 0xCAFE::MyModule::nonexistent_function;

    public fun test_self_assignment(x: u8): u8 {
        let a = x;
        if (a < 10) {
            a = a;
        } else {
            a = a;
        };
        a
    }

    public fun create_st(s: signer, v: u8) {
        let obj = St { val: v };
        move_to<St>(&s, obj);
    }

    public fun set_val(s: signer, v: u8) {
        let obj_ref = borrow_global_mut<St>(signer::address_of(&s));
        obj_ref.val = v;
    }

    public fun get_val(s: signer): u8 {
        let obj_ref = borrow_global<St>(signer::address_of(&s));
        obj_ref.val
    }

    // A function that does not abort
    public fun do_nothing(): u8 {
        7u8
    }

    spec do_nothing { 
        ensures result == 7;
        // example of no aborts
        succeeds_if true;
        decreases 0;
    }

    spec test_self_assignment {
        // whenever called with any x, result is x if x < 10 otherwise x
        ensures result == x;
        decreases 0;
    }

    spec create_st {
        modifies signer;
        ensures exists<St>(signer::address_of(&s));
        ensures (borrow_global<St>(signer::address_of(&s))).val == v;
        emits to StCreateEvent;
    }

    spec set_val {
        requires exists<St>(signer::address_of(&s));
        modifies signer;
        ensures (borrow_global<St>(signer::address_of(&s))).val == v;
        aborts_if !exists<St>(signer::address_of(&s));
        aborts_with 42;
    }

    spec get_val {
        requires exists<St>(signer::address_of(&s));
        ensures result == (borrow_global<St>(signer::address_of(&s))).val;
        aborts_if !exists<St>(signer::address_of(&s));
        aborts_with 42;
        decreases 0;
    }

    /// Event declaration for demonstration of 'emits' in spec
    struct StCreateEvent has copy, drop, store {}

}
