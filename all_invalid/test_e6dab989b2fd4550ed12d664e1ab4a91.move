//# publish
module 0xabc123::test_module {

    // Test that a variable reset inside a loop maintains its value after multiple iterations
    //# run
    public fun variable_reset_in_loop(p: u64): u64 {
        let mut accumulator = 0;
        let counter = 0;
        let mut i = counter;
        while (i < 5) {
            accumulator = p; // reset value in each iteration
            i = i + 1;
        };
        // After the loop, accumulator should hold the last reset value p
        accumulator
    }

    // Runner function
    //# run 0xabc123::test_module::variable_reset_in_loop --args 100

    // Test interaction with resource based on condition
    struct CounterResource has key {
        count: u64,
    }

    //# publish
    public fun initialize_counter(account: &signer, initial: u64) {
        move_to(account, CounterResource { count: initial });
    }

    //# run 0xabc123::test_module::modify_counter --signers 0xabc123 --args 10
    public fun modify_counter(account: &signer) {
        let r = borrow_global_mut<CounterResource>(@0xabc123);
        if (r.count > 5) {
            r.count = 0;
        } else {
            r.count = r.count + 1;
        }
    }

    //# run 0xabc123::test_module::modify_counter --signers 0xabc123
    public fun reset_or_increment(account: &signer) {
        let r = borrow_global_mut<CounterResource>(@0xabc123);
        if (r.count == 0) {
            r.count = 42;
        } else {
            r.count = r.count + 2;
        }
    }

    // Runner for resource test scenario
    //# run 0xabc123::test_module::initialize_counter --signers 0xabc123 --args 5
}