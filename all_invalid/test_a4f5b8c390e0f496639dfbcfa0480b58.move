//# publish
module 0x1234::LoopTestModule {
    fun test2(initial: u64): u64 {
        let counter = initial; // Initialize counter
        let sum = 0;           // Initialize sum accumulator
        let mut total = 0;     // Final total to be returned
        while ({  
            // Loop continues until counter reaches zero
            if (counter == 0) {
                break;                 // Break when counter is zero
            }
            sum = sum + counter;       // Add current counter value to sum
            counter = counter - 2;     // Decrease counter by 2 each iteration
            true                       // Continue loop
        }) {}
        total = sum + initial; // Final result: sum of decreasing values plus initial
        total
    }

    // Define a helper runner function to execute test2 with a predefined input
    public fun run_test2(): u64 {
        test2(10)
    }
}

//# run 0x1234::LoopTestModule::run_test2