//# publish
module 0xA55::stack {
    use std::vector;

    struct Stack<T> has key, drop {
        elements: vector<T>
    }

    public fun create<T>(): Stack<T> {
        Stack { elements: vector::empty() }
    }

    public fun push<T>(stack: &mut Stack<T>, item: T) {
        vector::push_back(&mut stack.elements, item);
    }

    public fun pop<T>(stack: &mut Stack<T>): T {
        let len = vector::length(&stack.elements);
        vector::remove(&mut stack.elements, len - 1)
    }

    // Test that pushing multiple items and then popping them retrieves items in LIFO order
    public fun test_stack_lifo() {
        let stack = create();
        push(&mut stack, 10);
        push(&mut stack, 20);
        push(&mut stack, 30);
        assert!(pop(&mut stack) == 30, 1);
        push(&mut stack, 40);
        assert!(pop(&mut stack) == 40, 2);
        assert!(pop(&mut stack) == 20, 3);
        assert!(pop(&mut stack) == 10, 4);
    }

    // Helper function to run the stack test
    public fun run_tests() {
        test_stack_lifo();
    }
}

//# run 0xA55::stack::run_tests

//# run
script {
    fun main() {
        // Loop with immediate break statement
        loop { break; }
    }
}

//# run
//# publish
module 0x99::callback_test {
    use 0xA55::stack;

    struct Counter has key, drop {
        count: u64
    }

    //# publish
    module 0x99::initializer {
        use 0x99::callback_test;
        use 0x42::callee;

        // Initialize the Counter resource for an address
        fun init_counter(s: &signer) {
            move_to(s, callback_test::Counter { count: 0 });
        }

        // Call a callback from within a confined lock
        #[module_lock]
        fun call_and_increment() acquires Counter {
            let counter_ref = &mut *callback_test::callbacks::get_counter();
            // Use callee to invoke callback
            callee::call_me(counter_ref, |x| callback_test::do_increment(x));
            // Increment again
            callback_test::do_increment(counter_ref);
        }

        // A helper function to retrieve the mutable reference to the counter resource
        public fun get_counter() acquires Counter: &mut Counter {
            // Assume resource exists
            move_from<Counter> // Placeholder; actual retrieval depends on resource management
        }
    }

    // For testing purposes, provide a function to initialize, call, and verify
    fun test_callback_inlock(s: &signer) {
        // Initialize the counter resource
        0x99::initializer::init_counter(s);
        // Call the function that invokes the callback
        0x99::initializer::call_and_increment();
        // (Assertions are omitted as per instructions)
    }
}
//# run 0x99::callback_test::test_callback_inlock --signers 0xA55