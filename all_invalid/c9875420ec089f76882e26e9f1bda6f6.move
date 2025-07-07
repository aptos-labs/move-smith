// #publish
module 0xCAFE::TestPublicBlockWhile {
    // A simple struct with store and key abilities so it can be stored in global storage
    struct Counter has store, key {
        value: u64,
    }

    // Public function to create a new Counter with initial value 0
    public fun new_counter(): Counter {
        Counter { value: 0 }
    }

    // Public function that runs a while loop to increment counter.value until it reaches 10
    // It uses a `block` expression to group two statements together: increment and a nop
    public fun run_while_loop(counter: &mut Counter) {
        let mut i = 0u64;
        while (i < 10) {
            // block expression groups multiple statements
            block {
                counter.value = counter.value + 1;
                let _ = 0u8; // nop inside block, just to test multiple expressions grouped
            }
            i = i + 1;
        }
    }

    // A public runner function that creates a counter and runs the while loop with it
    public fun runner() {
        let mut counter = new_counter();
        run_while_loop(&mut counter);
        // We don't assert, just exercise the logic.
        // If needed, the counter value would be 10 here.
    }
}
// #run 0xCAFE::TestPublicBlockWhile::runner

// Featurres:
// 2beb2e123eb15e2efe7550b4721dd692: Specify an item as publicly accessible with 'public'.
// e48927907b787fdbe897e6bb130f8a57: Verify that a while loop correctly updates a variable and exits when its condition becomes false.
// bd0d82d62d8269d2a5bd834f8a8fa85e: Group multiple expressions into a block with the `block` expression.
