//# publish --print-bytecode
module 0x50::test_module {
    // Function that attempts to access a key+drop resource, then drops it
    fun trigger_failure<T:key + drop>(addr: address) {
        // Ensure resource exists
        assert!(exists<T>(addr), 0);
        // Borrow global resource
        let _ref = borrow_global<T>(addr);
        // Drop the resource intentionally to test resource lifecycle
        move_from<T>(addr);
    }

    // Function that will call trigger_failure with a resource that has key + drop
    public fun call_trigger(s: &signer) {
        trigger_failure<ResourceWithKeyDrop>(@0x50);
    }

    // The resource with key + drop traits
    struct ResourceWithKeyDrop has key, drop {
        data: u64
    }

    // Helper function to set up the resource at deploy time (not called directly here)
    public fun initialize(s: &signer) {
        move_to<ResourceWithKeyDrop>(s, ResourceWithKeyDrop{data: 42});
    }
}

//# publish --print-bytecode
module 0x60::inline_test {
    // Function evaluating multiple inline code blocks with side effects
    public fun evaluate_inline_blocks(): u64 {
        let a = 5;
        // Increment a in side effect block
        let b = {
            // side effect: a = a + 2;
            // but since move semantics in script, simulate with local
            let a_local = a;
            a_local + 2
        };
        // Chain another inline block with side effects
        let c = {
            // side effect: b = b + 3;
            let b_local = b;
            b_local + 3
        };
        // Final expression combines all
        a + b + c
    }
}

//# run --signers 0x50
script {
    // The script to call the function that triggers failure
    fun main(account: signer) {
        0x50::test_module::call_trigger(&account);
    }
}

//# run 0x60::inline_test::evaluate_inline_blocks