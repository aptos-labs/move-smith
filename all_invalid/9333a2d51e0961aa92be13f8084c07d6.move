//# publish
module 0xCAFE::RobustnessTest {
    use std::error;
    use std::option;
    use std::signer;

    // 1. Handle unexpected or error types explicitly to maintain robustness in type handling.
    // We simulate an error variant and handle it explicitly.
    enum ResultType has copy, drop {
        Ok(u8),
        Err(error::Error),
        Unexpected
    }

    public fun test_error_handling(x: u8): u8 {
        let r = if (x == 0) {
            ResultType::Ok(42)
        } else if (x == 1) {
            // Create an arbitrary error using error::invalid_argument with error code 1001
            ResultType::Err(error::invalid_argument(1001))
        } else {
            ResultType::Unexpected
        };

        let val = match (r) {
            ResultType::Ok(v) => v,
            ResultType::Err(e) => {
                // Consume error, and return code 0 to indicate error case handled
                let _ = e;
                0
            },
            ResultType::Unexpected => {
                // Explicit handling for unexpected variant, return 255u8
                255u8
            }
        };
        val
    }

    // 2. Test that a mutable reference borrowed from a local variable can be used and dropped correctly
    //    across a while loop with assignment to the referenced value.
    public fun test_mut_ref_while_loop(): u8 {
        let mut x = 0u8;
        let r: &mut u8 = &mut x;

        while (*r < 5) {
            *r = *r + 1;
        };

        // *r should be 5 here
        *r
    }

    // 3. Test that variables declared before an if-else statement are correctly recognized
    //    as potentially uninitialized if a return occurs in one branch.
    public fun test_if_else_uninitialized(x: bool): u8 {
        let mut res: u8;

        if (x) {
            res = 1;
            return res;
        } else {
            // no initialization of res here
        };

        // If above return is correct, this line is only reached if x is false, and res is uninitialized.
        // We explicitly initialize res here to avoid uninitialized usage.
        res = 2;

        res
    }
}

//# run 0xCAFE::RobustnessTest::test_error_handling --args 0u8

//# run 0xCAFE::RobustnessTest::test_error_handling --args 1u8

//# run 0xCAFE::RobustnessTest::test_error_handling --args 2u8

//# run 0xCAFE::RobustnessTest::test_mut_ref_while_loop

//# run 0xCAFE::RobustnessTest::test_if_else_uninitialized --args true

//# run 0xCAFE::RobustnessTest::test_if_else_uninitialized --args false

// Featurres:
// dc5ee1ca41925945a696e57bf264d3a9: Handle unexpected or error types explicitly to maintain robustness in type handling.
// 9ca98640006c2bc250d521235dd91ba5: Test that a mutable reference borrowed from a local variable can be used and dropped correctly across a while loop with assignment to the referenced value.
// 9215ae1df667395735358a83241850e3: Test that variables declared before an if-else statement are correctly recognized as potentially uninitialized if a return occurs in one branch.
