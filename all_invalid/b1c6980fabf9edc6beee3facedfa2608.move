
//# publish
module 0xCAFE::LoopControlTest {
    use std::vector;

    // Function to test for loop, break, continue, and conditional modifications
    public fun test_for_loop_control(): u32 {
        let counter = 0u32;
        let limit = 10u32;
        let i = 0u32;

        // label: start_loop
        loop {
            // label: loop_body
            if (i >= limit) {
                break;
            }

            if (i % 2u32 == 0) {
                // label: even_branch
                counter = counter + i;
                // continue to next iteration
                i = i + 1u32;
                continue;
            } else {
                // odd branch
                if (i == 7u32) {
                    // label: special_break_point
                    break;
                }
                counter = counter + (i * 2);
                // move to next iteration
                i = i + 1u32;
            }
        };
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


//# run 0xCAFE::LoopControlTest::run_tests --signers 0xBEEF

// Featurres:
// cdd89ec6201f63d1f00c83114f52bb19: Test that the Move script correctly handles the combination of for-loop iteration, break, continue, and conditional modifications to a variable, resulting in the expected final value.
// 33d2256708c8f2c0dc85490da48fef02: Define labels at specific points in code to mark positions for jumps and control flow management.
// 057ed43b704e6042288e427679b31ffe: Ensure inline functions have their parameters properly checked for usage.
