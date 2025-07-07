//# publish
module 0xCAFE::LoopBreakTest {
    use std::debug;

    // Simple function to test break in while loop
    public fun test_break_in_while(): u64 {
        let mut sum = 0u64;
        let mut i = 0u64;
        // while loop increments i and sum
        while (true) {
            sum = sum + i;
            if (i == 5) {
                break;
            };
            i = i + 1;
        };
        // After break, sum should be 0+1+2+3+4+5 = 15. i = 5
        sum + i  // return sum+i = 15+5 = 20
    }

    // Test function that returns 100 after an if branch
    public fun test_if_return(): u64 {
        if (true) {
            // If condition true, return 100u64
            return 100u64;
        };
        0u64
    }

    // This function tests variable reassignment and tuple unpacking inside a loop
    // It loops 3 times, updating two variables using tuple unpacking
    public fun test_tuple_reassign(): (u64, u64) {
        let mut a = 1u64;
        let mut b = 10u64;

        let mut counter = 0u8;
        while (counter < 3) {
            // Reassign using tuple unpacking
            (a, b) = (b, a + b);
            counter = counter + 1;
        };

        // After loop:
        // Iter 0: a=10, b=11
        // Iter 1: a=11, b=21
        // Iter 2: a=21, b=32
        (a, b)
    }

    // Runner for the break test
    public fun runner_break(): u64 {
        test_break_in_while()
    }

    // Runner for the if-return test
    public fun runner_if(): u64 {
        test_if_return()
    }

    // Runner for tuple reassignment
    public fun runner_tuple(): (u64, u64) {
        test_tuple_reassign()
    }
}
//# run 0xCAFE::LoopBreakTest::runner_break
//# run 0xCAFE::LoopBreakTest::runner_if
//# run 0xCAFE::LoopBreakTest::runner_tuple

//# run
script {
    // Test the direct usage of break in while loop for side effect
    fun main() {
        let mut sum = 0u64;
        let mut i = 0u64;
        while (true) {
            sum = sum + i;
            if (i == 5) {
                break;
            };
            i = i + 1;
        };
        // sum + i = 15 + 5 = 20
        // no assert, just run it to test VM and compiler
        std::debug::print(&b"Break in while loop test sum+i executed\n");
    }
}

// Featurres:
// 597826eeb04ffbc6701b149cc4c8e094: Test that a break statement inside a while loop correctly exits the loop and updates variables as expected.
// 4ada9cbecf52d833f672887a3d040928: Test that the function returns 100 when called, ensuring the conditional branch executes correctly.
// d5ebdda52ab03427ef0ad5a20f79171f: Test that variable reassignment and tuple unpacking inside a loop behave correctly and produce expected values after the loop completes.
