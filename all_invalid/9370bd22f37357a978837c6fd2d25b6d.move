
//# publish
module 0xCAFE::HexAndAnonymousTest {
    use std::signer;
    use std::vector;

    struct Resource has key, store {
        data: vector<u8>,
        label: u8,
    }

    public fun create_resource(s: signer, label: u8, data: vector<u8>) {
        let res = Resource { data, label };
        move_to<Resource>(&s, res);
    }

    public fun consume_resource(s: signer): (u8, u64) {
        let res = move_from<Resource>(signer::address_of(&s));
        // Use anonymous pattern for dropping data vector immediately
        let Resource { label, data: _ } = res;
        // Return label and length of data (length ignored with _, but length here accessed before deconstruction)
        (label, vector::length(&res.data) as u64)
    }

    public fun mutate_resource_in_place(s: signer) {
        let r = borrow_global_mut<Resource>(signer::address_of(&s));
        // Anonymous pattern in a let binding tuple destructuring: ignore prior label
        let (new_label, _) = (r.label + 1, 0u8);
        r.label = new_label;
        // anonymous pattern to ignore old data while replacing it with hex literal
        let _ = std::mem::replace(&mut r.data, x"cafebabe");
    }

    public fun try_borrow_resource(addr: address): bool {
        if (exists<Resource>(addr)) {
            // Use anonymous pattern inside a block to isolate borrow_global
            let _res_ref = borrow_global<Resource>(addr);
            true
        } else {
            false
        };
    }

    // A lambda with an anonymous param, returning just the second param
    public fun lambda_anonymous_param(): u8 {
        let f: |u8, u8| u8 has copy = |_: u8, y: u8| { y };
        f(100, 200)
    }

    // Anonymous param inside inlined tuple destructuring
    public inline fun anon_param_tuple((_, b): (u8, u8)): u8 {
        b
    }

    // Function with anonymous param
    public fun anon_func_param(_: u8): u8 {
        123
    }

    public fun nested_shadowing_lambda(): u8 {
        let x = 10;
        let shadow_lambda = |x: u8| {
            // inner lambda shadows outer x parameter with _
            let inner_lambda = |_: u8| { x + 1 };
            inner_lambda(5u8)
        };
        shadow_lambda(x)
    }
}


//# run 0xCAFE::HexAndAnonymousTest::create_resource --signers 0xBEEF --args 42u8 x"DEADBEAFCAFEBABE"


//# run 0xCAFE::HexAndAnonymousTest::try_borrow_resource --args 0xBEEF


//# run 0xCAFE::HexAndAnonymousTest::mutate_resource_in_place --signers 0xBEEF


//# run 0xCAFE::HexAndAnonymousTest::try_borrow_resource --args 0xBEEF


//# run 0xCAFE::HexAndAnonymousTest::consume_resource --signers 0xBEEF


//# run 0xCAFE::HexAndAnonymousTest::lambda_anonymous_param


//# run 0xCAFE::HexAndAnonymousTest::anon_param_tuple --args 900u8 123u8


//# run 0xCAFE::HexAndAnonymousTest::anon_func_param --args 77u8


//# run 0xCAFE::HexAndAnonymousTest::nested_shadowing_lambda


//# publish
module 0xCAFE::ResourceAccessTest {
    use std::signer;

    struct InnerResource has store {
        value: u64,
    }

    struct TopResource has key, store {
        inner: InnerResource,
        counter: u64,
    }

    public fun create_top_resource(s: signer, initial: u64) {
        let inner = InnerResource { value: initial };
        let top = TopResource { inner, counter: 0 };
        move_to<TopResource>(&s, top);
    }

    public fun increment_counter(s: signer) {
        let top_mut = borrow_global_mut<TopResource>(signer::address_of(&s));
        let InnerResource { value } = &top_mut.inner;
        top_mut.counter = top_mut.counter + 1;
        // Shadow inner resource's field with anonymous pattern to ignore value
        let InnerResource { value: _ } = top_mut.inner;
    }

    public fun is_top_resource_present(addr: address): bool {
        exists<TopResource>(addr)
    }

    public fun try_borrow_inner_resource(addr: address): u64 {
        if (exists<TopResource>(addr)) {
            let top_ref = borrow_global<TopResource>(addr);
            top_ref.inner.value
        } else {
            0
        }
    }

    // Attempts unauthorized removal - should abort with error code 777 if resource does not exist or not signer
    public fun try_unauthorized_move_from(addr: address) {
        // We try to move_from without signer - expect abort if not present or no permissions
        let _  = move_from<TopResource>(addr);
    }
}


//# run 0xCAFE::ResourceAccessTest::create_top_resource --signers 0xBABE --args 1000u64


//# run 0xCAFE::ResourceAccessTest::is_top_resource_present --args 0xBABE


//# run 0xCAFE::ResourceAccessTest::increment_counter --signers 0xBABE


//# run 0xCAFE::ResourceAccessTest::try_borrow_inner_resource --args 0xBABE


//# run 0xCAFE::ResourceAccessTest::try_unauthorized_move_from --args 0xBABE


// Featurres:
// 4947e2dc96be91df82cbcc0e1daf10f7: Use hexadecimal string literals starting with 'x"' for hex-encoded byte data.
// e4b619ca6977b698919a76e517d85bd5: Test that the anonymous parameter pattern (_) can be used correctly in function definitions and inline closures, including in tuple destructuring, parameter lists, and lambdas, ensuring proper variable binding and shadowing behavior.
// 500933c97914f99890312aac314abd9b: Test the correct behavior of global resource access, mutation, existence checks, and proper error handling for unauthorized or invalid operations.
