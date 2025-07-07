
//# publish
module 0xCAFE::SpecTest {
    use std::signer;
    use std::vector;
    use std::event;

    struct Emitter has key {
        counter: u64,
        handle: event::EventHandle<u8>,
    }

    struct S has copy, drop, store {
        val: u64,
    }

    spec module {
        // Module-level invariant about Emitter counter
        invariant forall addr: address. 
            exists key: @Emitter 
            ensures key.counter >= 0;
    }

    public fun init_emitter(account: &signer) {
        let ev_handle = event::new_event_handle<u8>(account);
        let emitter = Emitter {
            counter: 0,
            handle: ev_handle,
        };
        move_to(account, emitter);
    }

    public fun increment_emitter_counter(account: &signer) acquires Emitter {
        let emitter_ref = borrow_global_mut<Emitter>(signer::address_of(account));
        emitter_ref.counter = emitter_ref.counter + 1;
        event::emit_event(&mut emitter_ref.handle, 42u8);
    }

    spec increment_emitter_counter {
        modifies Emitter;
        ensures exists key: @Emitter 
            && (borrow_global_mut<Emitter>(@key).counter > old(borrow_global_mut<Emitter>(@key).counter));
        emits Emitter(handle=_, counter=old(_)+1);
        requires exists @Emitter;
    }

    /// Tests mutable references and nested blocks with local variable assignments
    public fun scoped_blocks_test(x: u64): u64 {
        let val = x;

        {
            let inner = 10u64;
            val = val + inner;
            {
                val = val * 2;
                let block_val = val - 1;
                val = block_val;
            };
        };

        {
            let y = 3u64;
            val = val / y
        };

        val
    }

    /// Using nested mutable references and internal mutable assignments to test ref correctness
    public fun nested_ref_mutation(x: &mut u64): u64 {
        *x = *x + 1;

        {
            let inner_ref = x;
            *inner_ref = *inner_ref * 2;
            {
                let deeply_nested_ref = inner_ref;
                *deeply_nested_ref = *deeply_nested_ref + 3;
            };
        };
        *x
    }

    /// Function with abort conditions, success conditions, requires, and decreases clauses in spec
    public fun abort_and_spec_test(x: u64): u64 {
        assert!(x < 100, 1234);

        if (x == 0) {
            abort 5678;
        };

        x + 1
    }

    spec abort_and_spec_test {
        requires x < 200;
        aborts_if x == 0;
        ensures result == x + 1;
        decreases x;
    }
}


//# run 0xCAFE::SpecTest::init_emitter --signers 0xDEAD


//# run 0xCAFE::SpecTest::increment_emitter_counter --signers 0xDEAD


//# run 0xCAFE::SpecTest::scoped_blocks_test --args 5u64


//# run 0xCAFE::SpecTest::nested_ref_mutation --args 7u64


//# run 0xCAFE::SpecTest::abort_and_spec_test --args 5u64


//# run 0xCAFE::SpecTest::abort_and_spec_test --args 0u64


// Featurres:
// 4688ff0b245162f5b2dc82fe4c290e96: Add assertions, assumptions, decreases clauses, abort conditions, success conditions, modifies clauses, emits, ensures, and requires conditions in specifications.
// 214e5cb83bf9c538c57147b21f75e230: Test that local variable assignments and modifications within separate scoped blocks correctly affect the overall computation result.
// e107718a80b4b87e9076b2d2081b8129: Test that mutable references and assignments work correctly within nested block expressions in Move.
