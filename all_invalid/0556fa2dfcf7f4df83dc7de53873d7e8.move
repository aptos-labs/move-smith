module 0xCAFE::LoopControlTest {
    use std::vector;

    // Function to test for loop, break, continue, and conditional modifications
    public fun test_for_loop_control(): u32 {
        let counter = 0u32;
        let limit = 10u32;
        let i = 0u32;

        // start_loop
        loop {
            // loop_body
            if (i >= limit) {
                break;
            }

            if (i % 2u32 == 0) {
                // even_branch
                counter = counter + i;
                // move to next iteration
                i = i + 1u32;
                continue;
            } else {
                // odd_branch
                if (i == 7u32) {
                    // special_break_point
                    break;
                }
                counter = counter + (i * 2);
                // move to next iteration
                i = i + 1u32;
            }
        }; // End of loop

        counter
    }

    // Inline function with parameters checked for usage
    public inline fun inline_increment(x: u32): u32 {
        // use the parameter to avoid unused parameter warning
        let y = x + 1u32;
        y
    }

    // Runner function to invoke the test and inline function
    public fun run_tests(): (u32, u32) {
        let result = test_for_loop_control();
        let inc_result = inline_increment(result);
        (result, inc_result)
    }
}