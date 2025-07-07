//# publish
module 0xCAFE::test_module {
    use std::signer;
    use 0x42::foo;

    // Struct to hold a callback function for testing
    struct CallbackHolder {
        callback: fun() {
            // no fields needed
        }
    }

    // Function to receive a callback and call it
    public fun execute_callback(callback: &fun()) {
        callback();
    }

    // Function to invoke a callback inside a "locked" context; for testing module lock constraint
    public fun call_with_lock(account: &signer, callback: &fun()) {
        // Simulate acquiring module lock; in Move, module lock is conceptual,
        // but we can mimic mutability or resource borrow as lock
        // For test purposes, just call the callback
        callback();
    }

    // Runner function to test invoking an anonymous function that calls make_foo
    public fun run_make_foo() {
        // Call the anonymous function that calls foo::make_foo with 0x42
        let f = fun() {
            foo::make_foo(0x42);
        };
        f();
    }

    // Runner function to test executing callback inside lock
    public fun run_callback_in_lock() {
        // Create a dummy resource to modify
        // For simplicity, assume a resource to count callback invocations
        // (or just test that callback runs without error)
        // Since Move does not support capturing variables in nested functions,
        // we will just define an empty callback and call execute_callback
        fun() {
            // Dummy callback does nothing
        }
        // Call execute_callback with the dummy callback
        execute_callback(&fun() {});
        // Call with lock
        call_with_lock(&signer::address_of(&signer::borrow_global<s>().), &fun() {});
    }

    // Runner function to test variable assignment inside if statement
    public fun run_var_assignment_if() {
        let mut x = 1;
        if (true) {
            // Assign new value inside if
            x = 2;
        };
        // Final expression returns the value of x
        x
    }
}


//# run 0xCAFE::test_module::run_make_foo
//# run 0xCAFE::test_module::run_callback_in_lock --signers 0x123
//# run 0xCAFE::test_module::run_var_assignment_if