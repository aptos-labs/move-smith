//# publish
module 0xA11E::conditional_loop {
    use std::debug;

    public fun run_loop_with_conditional() {
        // Initialize a counter
        let mut counter = 0u64;

        // Loop executes and exits when counter reaches 3
        loop {
            if (counter >= 3) {
                // Exit the loop if condition met
                return;
            } else {
                // Increment counter
                counter = counter + 1;
            }
        }

        // After loop, check if counter is 3
        debug::print(&"Counter after loop:", &counter);
        // Unexpected: code should exit inside loop
    }
}

//# run 0xA11E::conditional_loop::run_loop_with_conditional

//# publish
module 0xBEEF::queue {
    use std::vector;

    struct Queue<T> has key, drop { data: vector<T> }

    public fun create<T>(): Queue<T> {
        Queue { data: vector::empty() }
    }

    public fun enqueue<T>(queue: &mut Queue<T>, item: T) {
        vector::push_back(&mut queue.data, item);
    }

    public fun dequeue<T>(queue: &mut Queue<T>): T acquires Queue {
        // Remove first item to maintain FIFO
        let item = vector::remove(&mut queue.data, 0);
        item
    }
}

//# run 0xBEEF::queue::create --signers 0xBEEF
//# run 0xBEEF::queue::enqueue --signers 0xBEEF --args 0u64
//# run 0xBEEF::queue::enqueue --signers 0xBEEF --args 1u64
//# run 0xBEEF::queue::enqueue --signers 0xBEEF --args 2u64
//# run 0xBEEF::queue::dequeue --signers 0xBEEF
//# run 0xBEEF::queue::dequeue --signers 0xBEEF
//# run 0xBEEF::queue::dequeue --signers 0xBEEF