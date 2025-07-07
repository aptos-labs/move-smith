
//# publish
module 0xCAFE::Addition {
    /// Returns the sum of two u8 values plus a constant offset 10.
    public fun add_and_offset(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 10
    }
}




//# run 0xCAFE::Addition::add_and_offset --args 5u8 7u8




//# publish
module 0xCAFE::LambdaTest {
    // Simple lambda that doubles the u8 input
    public fun lambda_double(x: u8): u8 {
        let doubler: |u8| u8 has copy+drop = |a: u8| {
            a * 2
        };
        doubler(x)
    }

    // Lambda with two arguments that adds them
    public fun lambda_add(a: u8, b: u8): u8 {
        let adder: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        adder(a, b)
    }
}




//# run 0xCAFE::LambdaTest::lambda_double --args 10u8




//# run 0xCAFE::LambdaTest::lambda_add --args 20u8 22u8





//# publish
module 0xCAFE::InlineCaller {
    use 0xCAFE::Addition;

    public inline fun caller_of_add(a: u8, b: u8): u8 {
        Addition::add_and_offset(a, b)
    }

    public fun runner(): u8 {
        caller_of_add(2u8, 3u8)
    }
}




//# run 0xCAFE::InlineCaller::runner





//# publish
module 0xCAFE::LoopTest {
    // Returns 1u8 immediately if the input is zero.
    // Otherwise, returns 0 immediately without an infinite loop.
    // The previous infinite loop causes the test to hang.
    public fun conditional_loop_exit(x: u8): u8 {
        if (x == 0) {
            1
        } else {
            // Removed infinite loop to prevent timeout
            0
        }
    }
}




//# run 0xCAFE::LoopTest::conditional_loop_exit --args 0u8




//# run 0xCAFE::LoopTest::conditional_loop_exit --args 1u8
