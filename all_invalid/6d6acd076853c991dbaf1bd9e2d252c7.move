
//# publish
module 0xCAFE::test_module {
    use std::debug;

    // Store a value inside the module for verification
    struct Counter has key {
        count: u64,
    }

    // Initialize the Counter object in global storage
    public fun init_counter(account: &signer) {
        move_to(account, Counter { count: 0 });
    }

    // Function with restricted access (only public in this example)
    public fun increment_counter(counter_ref: &mut Counter) {
        counter_ref.count = counter_ref.count + 1;
    }

    // Function to test local variable mutation in branches
    public fun test_local_mutation(val: u8): u8 {
        let local_var = val;
        if (local_var > 10) {
            local_var = local_var + 5;
        } else {
            local_var = local_var + 2;
        }
        // After branches, local_var should reflect the last mutation
        local_var
    }

    // Function to assign attribute using Assigned variant (simulate with attribute assignment analogy)
    public fun assign_attribute(counter: &mut Counter, new_value: u64) {
        counter.count = new_value; // simulating assignment of attribute
    }

    // Runner function for testing attribute assignment
    public fun run_tests() {
        // Initialize a counter in storage
        // Assuming signer at 0xBADD
        // For simplicity, initialize counter here
        let account = @0xBADD;
        init_counter(&signer references @0xBADD);
        // Additional test logic could go here
    }
}


//# run 0xCAFE::test_module::run_tests --signers 0xBADD




//# run
script {
    use 0xCAFE::test_module;

    fun main() {
        // Test local variable mutation in branches
        let result1 = test_module::test_local_mutation(12);
        let result2 = test_module::test_local_mutation(5);

        // Testing attribute assignment
        // Create a temporary Counter object
        let counter = test_module::Counter { count: 0 };
        test_module::assign_attribute(&mut counter, 42);
        // counter.count should now be 42
    }
}