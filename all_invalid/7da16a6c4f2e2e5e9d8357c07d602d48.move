//# publish
module 0x1::TestModule {
    use std::debug;

    // A function to test reference parameters with lambda functions
    public fun inline_ref_test<F>(f: &signer, lambda: fn(&u64, &u64) -> u64): u64 acquires None {
        let a: u64 = 10;
        let b: u64 = 20;
        lambda(&a, &b)
    }

    // Runner function to test the inline_ref_test
    public fun run_inline_ref_test<F>(f: &signer, lambda: fn(&u64, &u64) -> u64): u64 {
        inline_ref_test<&F>(f, lambda)
    }

    // Function to test the while loop counting from 0 to 5
    public fun count_loop(f: &signer): bool {
        let mut count: u64 = 0;
        while (count < 5) {
            count = count + 1;
        }
        // The loop should have terminated with count == 5
        assert!(count == 5, 42);
        true
    }
}

//# run
script {
    // Publish the module above
    // (Assumed to be published already if needed, or this step is just to compile)

    // Run the lambda function that adds the two values
    // Using a simple addition lambda
    fun main(signer: &signer) {
        let result = 0x1::TestModule::run_inline_ref_test<&u64>(
            signer,
            // Lambda that adds two u64 references
            |x: &u64, y: &u64| { *x + *y }
        );
        debug::print(&result);

        // Run the count loop to verify it counts from 0 to 5
        let success = 0x1::TestModule::count_loop(signer);
        debug::print(&success);
    }
}