// Fixed transactional test code for Aptos Move, correcting the signer address and syntax issues

//# publish
module 0xCAFE::TestModule {
    use std::vector;

    // Wrapper function to test nested block bindings and swaps
    public fun nested_blocks_sum(x: u8, y: u8): u16 {
        let total = 0u16;

        // Outer block: declare initial bindings
        {
            let a = x as u16;
            let b = y as u16;

            // Inner block: swap values and modify
            {
                let temp = a;
                let a = b;
                let b = temp;

                // Increment each by 1
                let a = a + 1;
                let b = b + 1;

                // Compute sum inside inner block
                let sum_in_block = a + b; // 16-bit sum
                // add to total
                total = total + sum_in_block;
            }
            // After inner block: a and b stay as their outer bindings
            // No modification here
        }

        // Return the total sum computed across blocks
        total
    }

    // Helper function to test nested generics with consecutive '>' tokens
    // Using nested Option types
    public fun nested_generic_example() {
        // Type expression: vector<Option<Option<u64>>>
        let nested_vector: vector<Option<Option<u64>>> = vector::empty();

        // Insert a nested value
        let value: Option<Option<u64>> = Option::some(Option::some(42u64));
        vector::push_back(&mut nested_vector, value);
    }

    // Runner function to invoke the above tests
    public fun run_tests() {
        // Call nested_blocks_sum with sample values
        let sum = nested_blocks_sum(3, 5);
        // Call nested_generic_example to test nested generics
        nested_generic_example();
    }
}

// Run command with a proper signer address, replacing '0xEMPTY' with a valid address
// Example: --signers 0x1
// To specify the Empty address, you can use 0x0 or a predefined constant if available


//# run 0xCAFE::TestModule::run_tests --signers 0x0
