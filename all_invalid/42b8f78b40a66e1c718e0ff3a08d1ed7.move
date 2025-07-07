//# publish
// This is a top-level file comment describing the module purpose: 
// Testing removal of trailing jumps, external checker retrieval, and file-level comments.
module 0xCAFE::TrailingJumpRemover {
    use std::signer;

    // A dummy resource struct with key capability
    struct Dummy has store, key {
        value: u64
    }

    /// Store a dummy resource at the signer's address
    public fun store_dummy(s: signer, val: u64) {
        let dummy = Dummy { value: val };
        move_to<Dummy>(&s, dummy);
    }

    /// Update dummy resource's value with increments in a loop, testing jump removal
    public fun increment_dummy(s: signer, count: u64): u64 {
        let addr = signer::address_of(&s);
        let dummy_ref = borrow_global_mut<Dummy>(addr);
        let mut acc = dummy_ref.value;
        let mut i = 0u64;
        while (i < count) {
            acc = acc + 1;
            i = i + 1;
        };
        dummy_ref.value = acc;
        acc
    }

    /// Withdraw dummy resource from the signer's account
    public fun withdraw_dummy(s: signer): u64 {
        let addr = signer::address_of(&s);
        let dummy = move_from<Dummy>(addr);
        dummy.value
    }

    /// Function to simulate retrieving expression checkers (dummy impl)
    public fun get_external_checkers(): u64 {
        // In practice this would return some collection or info.
        // Here it returns constant to simulate an external introspection.
        42
    }
}

//# run 0xCAFE::TrailingJumpRemover::store_dummy --signers 0xBEEF --args 10u64

//# run 0xCAFE::TrailingJumpRemover::increment_dummy --signers 0xBEEF --args 5u64

//# run 0xCAFE::TrailingJumpRemover::get_external_checkers

//# run 0xCAFE::TrailingJumpRemover::withdraw_dummy --signers 0xBEEF

// Featurres:
// 9eb7776ed6f83b78d2fb06e2e874c32c: Rely on the compiler to remove unnecessary trailing jump instructions from bytecode blocks
// b483f22d87a652baafe2edd66436de65: Retrieve all registered external expression checkers for the current module.
// dd5ae49180662dd16ec747e5d90fd681: Write Move source files that can include file-level comments matched to code definitions.
