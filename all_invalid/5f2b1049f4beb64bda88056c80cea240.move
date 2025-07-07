//# publish
module 0xABC::TestModule {
    use std::vector;
    use std::debug;
    use std::signer;
    use std::error;

    // Address literal with explicit byte sequence (0x1234)
    // Note: Move currently does not support raw byte sequences as address literals directly, so
    // we simulate this by defining a constant with the byte array.
    const BYTE_ADDRESS: vector<u8> = vector::from_owned(vec[0x12, 0x34]);

    // Function to log debug info with a custom message
    public fun log_debug_info(msg: &str, info: &vector<u8>) {
        debug::print(&msg);
        debug::print("Data: ");
        debug::print_bytes(info);
    }

    // Function to demonstrate a while loop increment
    public fun run_while_loop() {
        let counter = 0u64;
        let target = 5u64;
        let mut c = counter;

        while (c < target) {
            debug::print(&"Loop iteration");
            debug::print_u64(c);
            c = c + 1;
        }
        // Assert final condition
        assert!(c == target, 1);
    }

    // Function to create and manipulate let bindings
    public fun create_and_bind() {
        let base = 10u64;
        let offset = 20u64;
        let sum = base + offset; // let binding with expression
        debug::print_u64(sum);
        // Return sum for potential use
        sum;
    }

    // Function to remove an element from a vector at index
    public fun remove_element(vec: &mut vector<u64>, index: u64) {
        vector::remove(vec, index as usize);
    }

    // Function to demonstrate folding a vector sum
    public fun sum_vector(vec: &vector<u64>): u64 {
        let mut total = 0u64;
        let len = vector::length(vec);
        let mut i = 0;
        while (i < len) {
            total = total + *vector::borrow(vec, i);
            i = i + 1;
        }
        total
    }

    // Runner function to execute all demonstrations
    public fun run_all() {
        // Log debug info with source file name (simulate with a string)
        log_debug_info("Debug info for source move file: test.move", &BYTE_ADDRESS);

        // Run the while loop test
        run_while_loop();

        // Create and bind
        let sum_result = create_and_bind();
        debug::print_u64(sum_result);

        // Prepare vector and remove element
        let mut my_vec = vector::from_owned(vec[10, 20, 30, 40, 50]);
        remove_element(&mut my_vec, 2); // remove index 2 (element 30)
        // Verify fold sum
        let total_sum = sum_vector(&my_vec);
        debug::print_u64(total_sum);
    }
}

//# run 0xABC::TestModule::run_all