//# publish
module 0xCAFE::app {
    use std::signer;
    use std::signer::Signer;

    struct Data has key, store, copy, drop {
        value: u64,
    }

    public fun create(s: signer, val: u64) {
        let d = Data { value: val };
        move_to<Data>(&s, d);
    }

    public fun read(s: &signer): u64 acquires Data {
        let addr = signer::address_of(s);
        let d_ref = borrow_global<Data>(addr);
        d_ref.value
    }

    public fun update(s: &signer, val: u64) acquires Data {
        let addr = signer::address_of(s);
        let d_ref_mut = borrow_global_mut<Data>(addr);
        d_ref_mut.value = val;
    }
}

//# publish
module 0xCAFE::protected {
    use std::signer;
    use 0xCAFE::app;

    // NOTE: Move currently does NOT support type aliases for function types.
    // We remove the `public type` declarations and instead document the expected signatures.

    // Holder of function capabilities
    struct Permissions has key, store {
        read_fn: fun(&signer): u64,
        update_fn: fun(&signer, u64): (),
    }

    public fun init(s: signer) acquires Permissions {
        let perms = Permissions {
            read_fn: real_read,
            update_fn: real_update,
        };
        // Store permissions at signer's address
        move_to<Permissions>(&s, perms);
    }

    public fun read_proxy(s: &signer): u64 acquires Permissions {
        let perms_ref = borrow_global<Permissions>(signer::address_of(s));
        (perms_ref.read_fn)(s)
    }

    public fun update_proxy(s: &signer, val: u64) acquires Permissions {
        let perms_ref = borrow_global<Permissions>(signer::address_of(s));
        (perms_ref.update_fn)(s, val)
    }

    // Internal real implementations to be assigned to function fields
    public fun real_read(s: &signer): u64 acquires app::Data {
        app::read(s)
    }

    public fun real_update(s: &signer, val: u64) acquires app::Data {
        app::update(s, val)
    }

    // Runner to demonstrate usage without arguments
    public fun runner() {
        // dummy signer creation not possible in Move, skip here
    }
}

// This should trigger unknown attribute warning, testing that unknown attrs raise warning
// @unknown_attribute
module 0xCAFE::unknown_attr_test {
    struct Dummy has store {}

    public fun dummy_func() {}
}

// The attribute skipped by compiler flags - should suppress warning
// #[allow_unknown_attribute]
module 0xCAFE::skip_unknown_attr {
    struct Dummy2 has store {}

    public fun dummy_func() {}
}

// Pattern binding and source code range together in a single statement example in top level function
//# publish
module 0xCAFE::pattern_src {
    // Vector is unused, can remove or comment out
    // use std::vector;

    struct Bound has copy, drop {
        val: u8,
        start: u64,
        end: u64,
    }

    public fun bind_pattern() {
        // Bind pattern with value and fake source code range metadata
        let Bound { val: x, start: start_pos, end: end_pos } = Bound { val: 5u8, start: 10u64, end: 15u64 };
        // Usage to avoid unused var warnings
        let _ = x + (start_pos as u8) + (end_pos as u8);
    }
}

//# run 0xCAFE::app::create --signers 0xBEEF --args 42u64

//# run 0xCAFE::app::read --signers 0xBEEF

//# run 0xCAFE::app::update --signers 0xBEEF --args 84u64

//# run 0xCAFE::app::read --signers 0xBEEF

//# run 0xCAFE::protected::init --signers 0xBEEF

//# run 0xCAFE::protected::read_proxy --signers 0xBEEF

//# run 0xCAFE::protected::update_proxy --signers 0xBEEF --args 100u64

//# run 0xCAFE::protected::read_proxy --signers 0xBEEF

//# run 0xCAFE::pattern_src::bind_pattern