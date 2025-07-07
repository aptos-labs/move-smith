//# publish
module 0xCAFE::ReentrancyCallbackTest {
    use std::signer;
    use std::vector;
    use std::string;
    use std::option;
    use std::error;
    use std::account;

    // A resource that tracks a single u64 counter
    struct Counter has key, store {
        value: u64,
    }

    /// Initialize the counter resource under the signer
    public fun init_counter(account: &signer) {
        let counter = Counter { value: 0 };
        move_to(account, counter);
    }

    /// Increment the counter by 1. Called internally.
    fun increment(counter_ref: &mut Counter) {
        counter_ref.value = counter_ref.value + 1;
    }

    /// The callback function that increments the counter
    public fun callback(counter_ref: &mut Counter) {
        // This simulates code that runs as a callback and modifies the resource.
        increment(counter_ref);
    }

    /// The main function that runs the test: calls a callback within a resource context.
    public fun run_callback(account: &signer) {
        // Borrow mut ref to the stored Counter resource
        let counter_ref = borrow_global_mut<Counter>(signer::address_of(account));
        // Call a callback that operates on the resource
        callback(counter_ref);
        // Increment again here to confirm no reentrancy issues
        increment(counter_ref);
    }

    /// A runner function to initialize the resource and then call the callback-run function
    public fun run(account: &signer) {
        init_counter(account);
        run_callback(account);
    }
}
//# run 0xCAFE::ReentrancyCallbackTest::run --signers 0xCAFE

//# publish
module 0xCAFE::BlockLetBindings {
    /// Function to test declaring local variables inside nested code blocks using 'let'
    public fun test_let_bindings(): u64 {
        // Outer block
        {
            let (a, b) = (10u64, 20u64);

            // Inner block 1
            {
                let c = a + b;
                // Inner block 2
                {
                    let d = c * 2;
                    d
                }
            }
        }
    }
}
//# run 0xCAFE::BlockLetBindings::test_let_bindings

//# publish
module 0xCAFE::TypedLValueBinding {
    /// A struct with copy ability so it can be copied
    struct Pair has copy, drop, store {
        x: u8,
        y: u8,
    }

    /// Function to test reverse order processing of typed lvalue list and binding
    public fun bind_reverse_order(): u64 {
        // Here we use a tuple struct unpacking with typed LValues in reverse order,
        // simulating a reversed binding scenario.

        // Declare variables in reverse order intentionally:
        let (x: u8, y: u8) = (1, 2);
        
        // Now override the variables by unpacking with a new bind:
        // Process the list in reverse order: bind y first, then x
        let (y: u8, x: u8) = (3, 4);

        // Return sum to verify bindings
        (x as u64) + (y as u64)
    }
}
//# run 0xCAFE::TypedLValueBinding::bind_reverse_order