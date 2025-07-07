// 1: Argument evaluation order (left-to-right), aborts in earlier args stop later evaluation.

//# publish
module 0xCAFE::ArgOrderTest {
    use std::signer;

    // To record side effects, store a value in global storage as a resource.
    struct Counter has key, store { value: u64 }

    // Publish a counter under an address for test use.
    public fun publish_counter(account: &signer) {
        move_to(account, Counter { value: 0 });
    }

    // Sets the counter to a specific value (for reset).
    public fun set_counter(account: &signer, set: u64) {
        let counter = borrow_global_mut<Counter>(signer::address_of(account));
        counter.value = set;
    }

    // Increment the counter, then return an integer.
    public fun increment_and_return(account: &signer, ret: u64): u64 {
        let counter = borrow_global_mut<Counter>(signer::address_of(account));
        counter.value = counter.value + 1;
        ret
    }

    // Aborts with given code. (side effect: increments counter before abort)
    public fun aborting_arg(account: &signer, code: u64): u64 {
        let counter = borrow_global_mut<Counter>(signer::address_of(account));
        counter.value = counter.value + 10; // marker value
        abort code;
    }

    // A function that takes two arguments, to test arg evaluation order
    public fun combine(_x: u64, _y: u64): u64 {
        42
    }

    // Runner that exercises evaluation order: 
    // The first argument to combine will abort, so increment_and_return should NOT be called.
    // Counter should be increased by 10 ONLY.
    public fun run_left_abort(account: &signer) {
        Self::set_counter(account, 0);

        // Should abort before increment_and_return runs
        let _ = Self::combine(
            Self::aborting_arg(account, 1001),
            Self::increment_and_return(account, 123)
        );
    }

    // Runner where only second argument aborts, side effects of first are seen.
    public fun run_right_abort(account: &signer) {
        Self::set_counter(account, 0);

        let _ = Self::combine(
            Self::increment_and_return(account, 999),
            Self::aborting_arg(account, 1002)
        );
    }

    // Inspect the counter for test scripts
    public fun counter_val(addr: address): u64 {
        borrow_global<Counter>(addr).value
    }
}

//# run 0xCAFE::ArgOrderTest::publish_counter --signers 0xCAFE
//# run 0xCAFE::ArgOrderTest::set_counter --signers 0xCAFE --args 0u64
//# run 0xCAFE::ArgOrderTest::run_left_abort --signers 0xCAFE
//# run 0xCAFE::ArgOrderTest::set_counter --signers 0xCAFE --args 0u64
//# run 0xCAFE::ArgOrderTest::run_right_abort --signers 0xCAFE

// 2: Scripts with the same main function name (main), different bodies.
//# run
script {
    fun main() {
        // First "main" in test batch.
        let v = 1u8 + 2u8;
    }
}

//# run
script {
    fun main() {
        // Second script named "main", different computation.
        let s = 10u8 * 10u8;
    }
}

// 3: Attach custom attributes to constant declarations
//# publish
module 0xCAFE::ConstWithAttribute {
    #[my_custom_attribute]
    const FOO: u8 = 77;

    #[another_attribute(args = 2)]
    public const BAR: u64 = 0xCAFE;
}

// Featurres:
// a7c1901dfea9bbb19ae3c766a395ecf6: Test that argument evaluation order for function calls is left-to-right, including that aborts in earlier arguments prevent later arguments from being evaluated.
// bec8f12b899563b482c5a8f54ee72fde: Write scripts with potentially the same main function name, which are automatically disambiguated by the compiler.
// 46aa6ff6d1f82602874884f6d4367d13: Attach custom attributes to constant declarations in Move.
