//# publish
module 0xCAFE::PlusEqualsTest {
    use std::vector;

    struct Counter has copy, drop, store {
        val: u8
    }

    struct NestedCounter has copy, drop, store {
        inner: Counter,
        values: vector<u8>
    }

    struct GenericWrapper<T> has copy, drop {
        data: T
    }

    // Struct holding NestedCounter to test nested field access
    struct Holder has copy, drop, store {
        nested: NestedCounter,
    }

    // Emitting event to test 'emits' conditions
    struct Evt has copy, drop, store {
        id: u64,
    }

    struct EventHandle has key {
        counter: u64,
    }

    // Increment primitive u8 by plus-equals operator and manually
    public fun test_prim_plus_equals() {
        let mut x = 0u8;
        x += 1u8;
        let mut y = 0u8;
        y = y + 1u8;

        // Also test more increments on x to check the operator
        x += 2u8;
        y = y + 2u8;
    }

    // Increment struct field with plus-equals and explicit addition
    public fun test_struct_plus_equals() {
        let mut c = Counter { val: 0u8 };
        c.val += 1u8;
        let mut d = Counter { val: 0u8 };
        d.val = d.val + 1u8;
    }

    // Increment generic wrapper field that holds u8
    public fun test_generic_plus_equals() {
        let mut w = GenericWrapper<u8> { data: 0u8 };
        w.data += 1u8;
        let mut w2 = GenericWrapper<u8> { data: 0u8 };
        w2.data = w2.data + 1u8;
    }

    // Increment vector element by plus-equals and explicit addition
    public fun test_vector_plus_equals() {
        let mut v = vector::empty<u8>();
        vector::push_back(&mut v, 0u8);
        vector::push_back(&mut v, 1u8);

        let ref0 = vector::borrow_mut(&mut v, 0);
        *ref0 += 1u8;

        let ref1 = vector::borrow_mut(&mut v, 1);
        *ref1 = *ref1 + 1u8;
    }

    // Increment nested struct field and vector element inside nested struct
    public fun test_nested_plus_equals() {
        let mut nested = NestedCounter {
            inner: Counter { val: 0u8 },
            values: vector::empty<u8>(),
        };
        vector::push_back(&mut nested.values, 0u8);
        vector::push_back(&mut nested.values, 10u8);

        // Plus-equals on nested struct field
        nested.inner.val += 5u8;

        // Explicit addition on nested struct field
        nested.inner.val = nested.inner.val + 1u8;

        // Plus-equals on vector element inside nested struct
        let ref0 = vector::borrow_mut(&mut nested.values, 0);
        *ref0 += 2u8;

        // Explicit addition on vector element inside nested struct
        let ref1 = vector::borrow_mut(&mut nested.values, 1);
        *ref1 = *ref1 + 3u8;

        // Wrap nested struct in Holder to test deeper nesting increments
        let mut holder = Holder { nested };
        holder.nested.inner.val += 1u8;
        holder.nested.inner.val = holder.nested.inner.val + 1u8;
    }

    // Event Handle to test 'emits' conditions with to and if clauses
    struct EventHandleWithCounter has key {
        counter: u64,
    }

    public fun emit_event_test(h: &mut EventHandleWithCounter, id: u64, to: address, cond: bool) {
        // Declaring event emission with 'emits' keyword, with 'to' and 'if' conditions
        emits Evt to to if cond {
            let e = Evt { id };
            h.counter += 1;
        };
        emits Evt if !cond {
            let e = Evt { id: id + 1 };
            h.counter += 1;
        };
    }

    // Return string representation of current_token_loc for testing
    public fun test_current_token_loc(): vector<u8> {
        let loc = current_token_loc();
        // Combine file hash and positions into a vector<u8> for a rough output (unsafe but for testing)
        let mut out = vector::empty<u8>();

        // file_hash is vector<u8>, append it
        let file_hash = loc.file_hash;
        let len = vector::length(&file_hash);

        let mut i = 0;
        while (i < len) {
            vector::push_back(&mut out, *vector::borrow(&file_hash, i));
            i += 1;
        };

        // append start position (u32) as 4 bytes little endian
        vector::push_back(&mut out, (loc.start & 0xFF) as u8);
        vector::push_back(&mut out, ((loc.start >> 8) & 0xFF) as u8);
        vector::push_back(&mut out, ((loc.start >> 16) & 0xFF) as u8);
        vector::push_back(&mut out, ((loc.start >> 24) & 0xFF) as u8);

        // append end position (u32) as 4 bytes little endian
        vector::push_back(&mut out, (loc.end & 0xFF) as u8);
        vector::push_back(&mut out, ((loc.end >> 8) & 0xFF) as u8);
        vector::push_back(&mut out, ((loc.end >> 16) & 0xFF) as u8);
        vector::push_back(&mut out, ((loc.end >> 24) & 0xFF) as u8);

        out
    }

    public fun runner_emit_events() {
        let addr = @0xDEAD;
        let mut handle = EventHandleWithCounter { counter: 0 };

        emit_event_test(&mut handle, 42, addr, true);
        emit_event_test(&mut handle, 43, addr, false);
    }

    public fun runner_all() {
        test_prim_plus_equals();
        test_struct_plus_equals();
        test_generic_plus_equals();
        test_vector_plus_equals();
        test_nested_plus_equals();
        runner_emit_events();
        let _ = test_current_token_loc();
    }
}

//# run 0xCAFE::PlusEqualsTest::test_prim_plus_equals

//# run 0xCAFE::PlusEqualsTest::test_struct_plus_equals

//# run 0xCAFE::PlusEqualsTest::test_generic_plus_equals

//# run 0xCAFE::PlusEqualsTest::test_vector_plus_equals

//# run 0xCAFE::PlusEqualsTest::test_nested_plus_equals

//# run 0xCAFE::PlusEqualsTest::runner_emit_events

//# run 0xCAFE::PlusEqualsTest::test_current_token_loc

//# run 0xCAFE::PlusEqualsTest::runner_all

// Featurres:
// 60b8edac2927117d5a8f167f98050333: Test that the `+=` (plus-equals) operator works correctly and is equivalent to explicit addition and assignment (`x = x + 1`) for primitive types, struct fields, generic wrappers, vectors, and nested data structures.
// 38fafb719aeb13b8c89946422b7507a2: Declare 'emits' conditions with optional 'to' and 'if' clauses to specify event emissions and associated conditions.
// 15abb83042c457aeb22b394780f75c2e: Use the `current_token_loc` function to obtain the source code location, including file hash and start and end positions, of the current token in the lexer.
