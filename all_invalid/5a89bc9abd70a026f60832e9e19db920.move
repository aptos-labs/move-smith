
//# publish
module 0xCAFE::SpecAttachment {
    use std::signer;

    /// Module level spec
    spec module {
        invariant true;
    }

    /// Spec on a struct field -- NOTE: Move currently does not support `spec` attached directly on struct fields
    /// So we remove `spec val {}` inside the struct and put the invariant as module spec on the struct.
    struct ResourceWithSpec has key, store {
        val: u64,
        // Removed spec val { ensures val > 0; }
    }

    /// Resource with an invariant
    spec ResourceWithSpec {
        invariant val > 0;
    }

    /// Create resource with a positive value
    spec create_resource {
        requires v > 0;
        ensures old(!exists<ResourceWithSpec>(signer::address_of(s)));
        ensures exists<ResourceWithSpec>(signer::address_of(s));
        ensures borrow_global<ResourceWithSpec>(signer::address_of(s)).val == v;
    }
    public fun create_resource(s: signer, v: u64) {
        assert!(v > 0, 1000);
        move_to<ResourceWithSpec>(&s, ResourceWithSpec { val: v });
    }

    /// Read resource and return val
    public fun read_resource_val(s: signer): u64 {
        let r = borrow_global<ResourceWithSpec>(signer::address_of(&s));
        r.val
    }

    /// Update resource val with assertions and spec
    spec update_resource_val {
        requires v > 0;
        ensures old(borrow_global<ResourceWithSpec>(signer::address_of(s)).val) < v;
        ensures borrow_global<ResourceWithSpec>(signer::address_of(s)).val == v;
    }
    public fun update_resource_val(s: signer, v: u64) {
        let r = borrow_global_mut<ResourceWithSpec>(signer::address_of(&s));
        assert!(v > r.val, 1001);
        r.val = v;
    }

    /// A function with complex spec and body
    spec complex_fn {
        ensures result == 42;
    }
    public fun complex_fn(): u8 {
        let a = 40u8;
        let b = 2u8;
        let c = a + b;
        assert!(c == 42, 42);

        // pattern binding
        let (x, y) = (10u8, 32u8);

        // nested expressions
        let z = if (x < y) { c } else { 0u8 };
        z
    }
}



//# run 0xCAFE::SpecAttachment::create_resource --signers 0xBEEF --args 1u64



//# run 0xCAFE::SpecAttachment::read_resource_val --signers 0xBEEF



//# run 0xCAFE::SpecAttachment::update_resource_val --signers 0xBEEF --args 5u64



//# run 0xCAFE::SpecAttachment::complex_fn





//# publish
module 0xCAFE::ReachabilityAnnotations {
    use std::signer;

    /// Function to annotate reachability at specific code offsets

    /// Function with unreachable statement and assertions
    public fun unreachable_code_example(x: u8): u8 {
        if (x > 10) {
            10;
            // offset: reachable
            20;
        } else {
            // offset: reachable
            30;
            return 30;
            // offset: unreachable
            40;
        };
        // offset: unreachable (because return in else)
        50;
        60
    }

    /// A function with iterative and loop with break
    public fun loop_reachability(n: u8): u8 {
        let sum = 0u8;
        // Move does NOT support for (i in 1..=n) syntax.
        // Use while loop or for loop over vector if needed. We'll just use a while loop here.
        let i = 1u8;
        while (i <= n) {
            if (i == 5) {
                break;
            };
            sum = sum + i;
            i = i + 1;
        };
        sum
    }

    /// Function with dead code after abort
    public fun abort_test(flag: bool): u8 {
        if (flag) {
            abort 100;
            // offset: dead (after abort)
            200;
        };
        1u8
    }

    /// Function with multiple returns and annotated reachability
    public fun multi_return(x: u8): u8 {
        if (x < 5) {
            // offset: reachable
            return 1;
            // offset: unreachable
            return 0;
        } else if (x == 5) {
            return 5;
        };
        10
    }
}



//# run 0xCAFE::ReachabilityAnnotations::unreachable_code_example --args 3u8



//# run 0xCAFE::ReachabilityAnnotations::unreachable_code_example --args 20u8



//# run 0xCAFE::ReachabilityAnnotations::loop_reachability --args 10u8



//# run 0xCAFE::ReachabilityAnnotations::abort_test --args true



//# run 0xCAFE::ReachabilityAnnotations::abort_test --args false



//# run 0xCAFE::ReachabilityAnnotations::multi_return --args 3u8



//# run 0xCAFE::ReachabilityAnnotations::multi_return --args 5u8



//# run 0xCAFE::ReachabilityAnnotations::multi_return --args 10u8





//# publish
module 0xCAFE::SpecAndReachCombine {

    use std::signer;

    /// Spec attached to a member function which has complex body with reachability annotations

    struct Data has store, key {
        value: u64,
    }

    spec Data {
        invariant value < 1000;
    }

    /// Create data with assertion and spec requires
    spec create {
        requires v < 1000;
        // old(value) is not available here because resource not yet exists – so just skip old(value)
        ensures exists<Data>(signer::address_of(s));
        ensures borrow_global<Data>(signer::address_of(s)).value == v;
    }
    public fun create(s: signer, v: u64) {
        assert!(v < 1000, 1234);
        move_to<Data>(&s, Data { value: v });
    }

    /// Function with multiple specs and reachability marks
    spec update_value {
        requires new_v < 1000;
        ensures old(borrow_global<Data>(signer::address_of(s)).value) < new_v;
        ensures borrow_global<Data>(signer::address_of(s)).value == new_v || borrow_global<Data>(signer::address_of(s)).value == new_v - 1;
    }
    public fun update_value(s: signer, new_v: u64) {
        let d_ref = borrow_global_mut<Data>(signer::address_of(&s));
        assert!(new_v > d_ref.value, 4321);
        d_ref.value = new_v;

        if (new_v > 500) {
            // Spec: reachable block
            let _x = 1;
            // unreachable code after return statement
            return;
            // dead code offset: unreachable
            let _y = 2;
        };

        // Spec: reachable block after if
        d_ref.value = new_v - 1;
    }

    /// Function combining spec, pattern binding, and reachability
    spec combined_fn {
        ensures result == 1000;
    }
    public fun combined_fn(): u64 {
        let a = 500u64;
        let b = 500u64;

        // pattern binding for tuple
        let (_c, _d) = (100u64, 200u64);

        if (a + b == 1000) {
            // reachable offset example
            a + b;
        } else {
            // dead code offset: unreachable
            0;
        };

        a + b
    }
}



//# run 0xCAFE::SpecAndReachCombine::create --signers 0xBEEF --args 10u64



//# run 0xCAFE::SpecAndReachCombine::update_value --signers 0xBEEF --args 600u64



//# run 0xCAFE::SpecAndReachCombine::update_value --signers 0xBEEF --args 400u64



//# run 0xCAFE::SpecAndReachCombine::combined_fn
