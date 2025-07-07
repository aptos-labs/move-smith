
//# publish
module 0xDEAD::NestedControlFlow {
    // Use attribute on specific imports
    // import_attribute]
    use std::vector;

    // Resource for testing resource access
    struct Counter {
        count: u64,
    }

    public fun init_counter(signer: signer): Counter {
        move_to<Counter>(&signer, Counter { count: 0 })
    }

    // Function to read resource value
    public fun get_counter_value(counter_ref: &Counter): u64 {
        counter_ref.count
    }

    // Inline function that borrows the global counter resource
    public inline fun read_global_counter(counter_ref: &Counter): u64 {
        get_counter_value(counter_ref)
    }

    // Function that calls the inline and reads resource
    public fun call_inline_and_borrow(s: signer): u64 {
        let counter_ref: &Counter = borrow_global<Counter>(signer::address_of(&s));
        read_global_counter(counter_ref)
    }

    // Diagnostic message generator
    public fun generate_diagnostics(outer_var: u64, inner_var: u64): vector<vector<u8>> {
        let messages = vector::empty<vector<u8>>();

        let msg1 = b"Diagnostic: outer_var=", vector::empty<u8>();
        vector::append(&mut msg1, u234_to_bytes(outer_var));
        vector::push_back(&mut messages, msg1);

        let msg2 = b" inner_var=", vector::empty<u8>();
        vector::append(&mut msg2, u234_to_bytes(inner_var));
        vector::push_back(&mut messages, msg2);

        messages
    }

    // Helper function to convert u64 to bytes (simulate)
    fun u234_to_bytes(val: u64): vector<u8> {
        // simplistic conversion for test (big endian)
        vector::singleton(0x00)
    }

    // Nested control flow with loop and if-continue
    public fun nested_loop_control(x: u64): u64 {
        let result = 0;
        let counter = 0;
        while (counter < 10) {
            if (x % 2 == 0) {
                // If x is even, continue to next iteration
                counter = counter + 1;
                continue;
            } else {
                // Break the loop if x is odd
                break;
            };
            result = result + counter;
            counter = counter + 1;
        };
        result
    }

    // Variable scope inside and outside loops
    public fun variable_scope_test(flag: bool): u64 {
        let outer_var = 42;
        let inside_var = 0;

        let i = 0;
        while (i < 5) {
            // Shadowing: create a new variable inside loop
            let inside_var = i as u64;
            i = i + 1;
        };
        // outside variable remains unchanged
        outer_var + inside_var
    }

    // Address assignment string validation
    public fun validate_address_format(addr_str: vector<u8>): bool {
        // Check that exactly one '=' character
        let count_equal = 0;
        let i = 0;
        while (i < vector::length(&addr_str)) {
            if (*vector::borrow(&addr_str, i) == 0x3D) {
                count_equal = count_equal + 1;
            };
            i = i + 1;
        };
        // valid if exactly one '='
        count_equal == 1
    }

    // Use declarations with attributes
    // use_attribute]
    use 0xDEAD::NestedControlFlow::generate_diagnostics;
    // use_attribute]
    use 0xDEAD::NestedControlFlow::nested_loop_control;

    // Runner function to invoke resource and diagnostics behaviors
    public fun run_all(signer: signer): u64 {
        // Initialize counter resource
        let _counter = init_counter(&signer);
        // Call inline + resource access
        let val = call_inline_and_borrow(&signer);
        // Generate diagnostics
        let diag_msgs = generate_diagnostics(123, 456);
        // Run nested loop control
        let nested_result = nested_loop_control(3);
        // Variable scope test
        let scope_result = variable_scope_test(true);
        // Return sum as a placeholder
        val + nested_result + scope_result
    }
}


//# run 0xDEAD::NestedControlFlow::run_all --signers 0xBADD


// Featurres:
// 312e4630fd94dea2ace81bdc0229c624: Test that nested if-continue statements correctly interact with an outer loop, allowing the loop to break when the condition is false.
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 38c8fed9c8f68f65a6ce8f0a9b4bc138:  Validate that the address assignment string is correctly formatted with exactly one '=' character.
// a618575568cc48edf7aa4150c6567ef8: Attach attributes to individual 'use' declarations inside your script.
// c64d4c4c120027053db915b639944508: Verify that a public function calling an inline function, which in turn borrows and reads a global resource, correctly retrieves the integer value stored in the resource.
// bb5d4592f2188bdb68d5196965acc999: Generate a buffer containing formatted diagnostic messages
