// This test demonstrates:
// 1. Defining inline and native functions in modules, with and without bodies.
// 2. Using basic specifications and applies of spec snippets.
// 3. Flushing writes with `aptos_std::storage::flush` for storage ordering.

//-------------------------------------------
//# publish
module 0xCAFE::SpecAndInlineTest {
    use aptos_std::storage;

    // A struct to store a simple counter.
    struct Counter has key, store {
        val: u64,
    }

    // Inline function to increment a counter by a value
    public inline fun fast_increment(addr: address, v: u64) acquires Counter {
        let counter = borrow_global_mut<Counter>(addr);
        counter.val = counter.val + v;
    }

    // A native function: declared but not implemented in Move.
    native public fun compute_native(val: u64): u64;

    /// A function that processes and flushes storage.
    public fun demo(addr: signer) acquires Counter {
        let a = signer::address_of(&addr);

        // Publish the Counter resource if it does not exist
        if (!exists<Counter>(a)) {
            move_to(&addr, Counter { val: 0 });
        }

        fast_increment(a, 13);
        let counter = borrow_global_mut<Counter>(a);
        counter.val = counter.val * 2;

        // Force the virtual machine to flush all pending writes to storage
        storage::flush();

        // Call a native function (stub; just for syntactic test)
        let _nval = compute_native(counter.val);

        // Incrememnt again to check ordering after flush
        fast_increment(a, 7);
        storage::flush();
    }

    /// "Runner" entrypoint for transactional test
    public fun runner(addr: signer) acquires Counter {
        demo(addr);
    }

    // Simple function with specification
    public fun get_val(addr: address): u64 acquires Counter {
        borrow_global<Counter>(addr).val
    }

    /// Spec block for get_val
    spec get_val {
        // For illustration: val must be more than or equal zero (trivial for u64)
        ensures result >= 0;
    }

    // Spec snippet applied to multiple funs
    spec snippet IncreaserEnsures {
        ensures old(borrow_global<Counter>(addr).val) <= borrow_global<Counter>(addr).val;
    }

    spec fast_increment {
        include IncreaserEnsures;
    }
}

//# run 0xCAFE::SpecAndInlineTest::runner --signers 0xCAFE

//-------------------------------------------
//# publish
module 0xCAFE::CallerFlushTest {
    use 0xCAFE::SpecAndInlineTest;
    use aptos_std::storage;

    /// A function that increments, flushes, and queries state intentionally.
    public fun runner(addr: signer) {
        let a = signer::address_of(&addr);

        SpecAndInlineTest::fast_increment(a, 21);
        storage::flush();

        // Try calling the native function (syntactic VM test—will abort at runtime if no native impl)
        // let _res = SpecAndInlineTest::compute_native(10);

        let val = SpecAndInlineTest::get_val(a);
        // Use val to avoid lint warnings
        let _ = val;
    }
}

//# run 0xCAFE::CallerFlushTest::runner --signers 0xCAFE

// Featurres:
// 3be5c5b2d436a95950a6921062710e99: Define functions in modules, specifying whether they are inline or native, and include optional bodies.
// 8d473f267650e8e46360ffed19f09ded: Include other specifications or apply specification snippets.
// 1e5a78734c41f2f7d1ec3edbf78b080a: Flush write instructions to ensure proper ordering and optimize write operations.
