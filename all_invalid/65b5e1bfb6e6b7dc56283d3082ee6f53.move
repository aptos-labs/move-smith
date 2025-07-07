
//# publish
module 0xCAFE::DiagnosticsSorting {
    use std::string;
    use std::vector;

    // A simple resource to create errors upon misuse
    struct ErrorResource has key, store {
        val: u8,
    }

    // Store an ErrorResource at the address
    public fun store_error_resource(addr: address, val: u8) {
        if (!exists<ErrorResource>(addr)) {
            move_to<ErrorResource>(&signer::borrow_address(addr), ErrorResource { val });
        }
    }

    // Function that triggers errors at unsorted locations to test diagnostic sorting
    public fun trigger_unsorted_errors() {
        let addr = @0xCAFE;
        // Condition 1: no error
        if (false) {
            abort 0;
        };

        // Condition 2: abort with smaller code should appear first in diagnostics
        abort 2;

        // Condition 3: abort with larger code appears later
        abort 10;
    }

    // Function demonstrating sorting by primary location by causing multiple aborts with location indices
    public fun multiple_abort_sorting() {
        for (i in 0..3) {
            if (i == 2) {
                abort 100; // intentionally abort at iteration 2
            };
        };
        // This won't be reached
    }

    // Runner function to test ordering when multiple errors occur and ensure diagnostics are sorted
    public fun run_sorting_tests() {
        // Call functions that cause aborts in unsorted location order
        // They are expected to be logged sorted by location by the compiler tooling
        let _ = Self::trigger_unsorted_errors();
        let _ = Self::multiple_abort_sorting();
    }
}


//# run 0xCAFE::DiagnosticsSorting::run_sorting_tests



//# publish
module 0xCAFE::FriendAccessChains {
    // This module tests friend specification with various name access chains

    struct S has key, store {
        x: u8,
    }

    friend 0xCAFE::FriendAccessChainsFriend;              // direct friend module
    friend 0xCAFE::FriendAccessChains::inner::FriendMore; // friend with 3-component chain
    friend 0xCAFE::FriendAccessChains::inner::deeper::FriendDeepest; // 4-component chain

    public fun create_resource(s: &signer, val: u8) {
        let r = S { x: val };
        move_to<S>(s, r);
    }

    public fun access_resource_direct(s: &signer) {
        let r_ref = borrow_global<S>(signer::address_of(s));
        let _v = r_ref.x;
    }

    public fun access_resource_via_inner(s: &signer) {
        let r_ref = borrow_global<S>(signer::address_of(s));
        let _v = r_ref.x;
    }

    // Runner that does nothing but ensures friend attributes with different chain lengths compile
    public fun friend_name_access_chains_noop() {
        // dummy function
    }
}


//# run 0xCAFE::FriendAccessChains::friend_name_access_chains_noop



//# publish
module 0xCAFE::FriendAccessChainsFriend {
    use std::signer;

    struct S has key, store {
        y: u8,
    }

    public fun store_resource(s: &signer, v: u8) {
        let r = S { y: v };
        move_to<S>(s, r);
    }
}


//# publish
module 0xCAFE::FriendAccessChains::inner::FriendMore {
    use std::signer;

    struct S has key, store {
        y: u64,
    }

    public fun store_resource(s: &signer, v: u64) {
        let r = S { y: v };
        move_to<S>(s, r);
    }
}


//# publish
module 0xCAFE::FriendAccessChains::inner::deeper::FriendDeepest {
    use std::signer;

    struct S has key, store {
        y: u128,
    }

    public fun store_resource(s: &signer, v: u128) {
        let r = S { y: v };
        move_to<S>(s, r);
    }
}



//# publish
module 0xCAFE::TempFlush {
    // Module to test explicit flush operations and resource writes
    use std::signer;

    struct R has key, store {
        x: u64,
    }

    // Create resource at signer's address
    public fun create_resource(s: &signer, val: u64) {
        move_to<R>(s, R { x: val });
    }

    // Borrow mut and update resource field
    public fun update_resource(s: &signer, val: u64) {
        let r_ref = borrow_global_mut<R>(signer::address_of(s));
        r_ref.x = val;
    }

    // Simulate explicit flush by removing and re-storing resource
    public fun flush_temp(s: &signer) {
        let r = move_from<R>(signer::address_of(s));
        move_to<R>(s, r);
    }

    // Incorrect use of temp flush to trigger diagnostic error (e.g., flush when no resource exists)
    public fun flush_no_resource(s: &signer) {
        let dummy = move_from<R>(signer::address_of(s)); // will abort if not exists
        move_to<R>(s, dummy);
    }

    // Runner function: create resource, update it, flush explicitly
    public fun runner_flush_test(s: &signer) {
        create_resource(s, 42);
        update_resource(s, 84);
        flush_temp(s);
    }
}


//# run 0xCAFE::TempFlush::runner_flush_test --signers 0xBEEF


//# run 0xCAFE::TempFlush::flush_no_resource --signers 0xCAFE



//# publish
module 0xCAFE::CombinedDiagnosticsFriendFlush {
    use std::signer;
    use std::vector;

    // Combine diagnostics sorting, friend resolution & flush semantics
    struct Res has key, store {
        val: u8,
    }

    friend 0xCAFE::CombinedDiagnosticsFriendFlushFriend;

    public fun create_resource(s: &signer, v: u8) {
        move_to<Res>(s, Res { val: v });
    }

    // This function causes errors after flush operation, testing diagnostic sorting and correctness
    public fun flush_and_abort(s: &signer, should_abort: bool) {
        // flush resource explicitly by move_from/move_to
        let r = move_from<Res>(signer::address_of(s));
        move_to<Res>(s, r);
        if (should_abort) {
            abort 404;
        };
    }

    // Calls friend module's function after flushing resource to check friend access correctness with flushes
    public fun call_friend_after_flush(s: &signer) {
        let r = move_from<Res>(signer::address_of(s));
        move_to<Res>(s, r);
        0xCAFE::CombinedDiagnosticsFriendFlushFriend::friend_func(s);
    }

    // Runner function triggers flush followed by friend call with correct access chain
    public fun runner_combined(s: &signer) {
        create_resource(s, 99);
        flush_and_abort(s, false);
        call_friend_after_flush(s);
    }
}


//# run 0xCAFE::CombinedDiagnosticsFriendFlush::runner_combined --signers 0xBEEF


//# run 0xCAFE::CombinedDiagnosticsFriendFlush::flush_and_abort --signers 0xBEEF --args true



//# publish
module 0xCAFE::CombinedDiagnosticsFriendFlushFriend {
    use std::signer;

    struct Res has key, store {
        val: u8,
    }

    public fun friend_func(s: &signer) {
        let r = borrow_global<Res>(signer::address_of(s));
        let _dummy = r.val;
    }
}


// Featurres:
// d841ea59cfe5c6ef8cd86075c88d17d4: Sort diagnostics report entries by their primary location to organize error messages.
// 431feb4d6c714a223a719930f11d883b: Specify the friend entity or module using a name access chain.
// 7c69fdb8d9d254bab76956f7cd2f046c: Insert explicit flush operations for temporary variables at specific program points to manage resource writes.
