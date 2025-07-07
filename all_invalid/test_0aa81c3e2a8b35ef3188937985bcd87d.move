//# publish
module 0xABCDEF::increment_loop {
    // Runner function to initialize and start the loop test
    public fun run_loop_test() {
        main();
    }

    fun main() {
        let counter = 0;
        // Loop that increments 'counter' until it reaches 10
        while (true) {
            if (counter >= 10) break;
            // Conditionally skip increment if counter is even
            if (counter % 2 == 0) {
                counter = counter + 1;
                continue;
            }
            // For odd counters, double the value
            counter = counter + counter;
        }
        // Final assertion to check the counter value
        assert!(move counter == 21, 99);
    }
}

 //# run 0xABCDEF::increment_loop::run_loop_test

//# publish
module 0x123456::addition_abort {
    public fun test() : u8 {
        // Adding with a nested abort within the expression
        { 100u8 + 50u8 } + {abort 77; 5u8 }
    }
}

//# run 0x123456::addition_abort::test