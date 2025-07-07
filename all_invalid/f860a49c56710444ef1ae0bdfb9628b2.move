
//# publish
module 0xCAFE::SpecTest {
    use std::signer;
    use std::event;

    struct St has copy, drop, store {
        val: u8,
    }

    /// Event declaration for demonstration of 'emits' in spec
    struct StCreateEvent has copy, drop, store {}

    // Add event handle to the module
    struct EventHolder has key {
        st_create_handle: event::EventHandle<StCreateEvent>,
    }

    // Initialize EventHolder in module publishing address
    public fun init_module(s: &signer) {
        let addr = signer::address_of(s);
        if (!exists<EventHolder>(addr)) {
            move_to<EventHolder>(s, EventHolder {
                st_create_handle: event::new_event_handle<StCreateEvent>(s),
            });
        }
    }

    public fun test_self_assignment(x: u8): u8 {
        let a = x;
        if (a < 10) {
            let a = a;
        } else {
            let a = a;
        };
        a
    }

    public fun create_st(s: &signer, v: u8) {
        let obj = St { val: v };
        move_to<St>(s, obj);
        // emit event
        let holder_ref = borrow_global_mut<EventHolder>(signer::address_of(s));
        event::emit_event(&mut holder_ref.st_create_handle, StCreateEvent {});
    }

    public fun set_val(s: &signer, v: u8) {
        let obj_ref = borrow_global_mut<St>(signer::address_of(s));
        obj_ref.val = v;
    }

    public fun get_val(s: &signer): u8 {
        let obj_ref = borrow_global<St>(signer::address_of(s));
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
        emits to signer::address_of(&s) StCreateEvent;
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
}
