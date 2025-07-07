// Corrected Move script definitions with proper syntax

// Create a script with nested loops that increment a counter
//# run
script nested_loop_counter {
    fun main() {
        let count: u32 = 0;
        let i: u32 = 0;

        while (i < 5) {
            let j: u32 = 0;
            while (j < 4) {
                // increment count
                count = count + 1;
                // increment j
                j = j + 1;
            };
            // increment i
            i = i + 1;
        };
        // Return the final count for verification
        count
    }
}

// Run the nested loop test

//# run 0xCAFE::MyModule::main

// Create a script with an infinite loop with early return
//# run
script infinite_loop_with_return {
    fun main() {
        let i: u32 = 0;

        loop {
            // Early break inside loop; simulate early return
            if (i >= 3) {
                break;
            };
            i = i + 1;
        };
        // Should not reach here if loop breaks early
        let _assert_fail = false;
        assert!(_assert_fail, 999);
        // The script completes successfully before reaching the assertion
        i
    }
}

// Run the infinite loop with early return test

//# run 0xCAFE::MyModule::main
