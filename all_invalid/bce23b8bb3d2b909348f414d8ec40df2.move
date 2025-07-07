//# publish
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
    }
}
//# run 0xCAFE::TestPublicBlockWhile::runner