//# publish
module 0xCAFE::LambdaAbortTest {
    use std::signer;

    struct Dummy has copy, drop {
        val: u8
    }

    public fun run_lambda_with_capture_abort(x: u8) {
        let dummy = Dummy { val: x };
        let lambda: |u8| u8 has copy+drop = |y: u8| {
            // Capture dummy by immutable borrow (copy is allowed too)
            let _ = dummy.val; 
            if (y == 42) {
                abort 123; // test abort statement
            };
            y + dummy.val
        };
        let _result = lambda(41u8);
        let _ = lambda(42u8); // This triggers abort
    }

    public fun run_lambda_block() {
        let block_lambda: |u8| u8 has copy+drop = |z: u8| {
            {
                let t = z * 2;
                t + 1
            }
        };
        let _ = block_lambda(5u8);
    }
}

//# run 0xCAFE::LambdaAbortTest::run_lambda_block

//# run 0xCAFE::LambdaAbortTest::run_lambda_with_capture_abort --args 10u8

// Featurres:
// 27c583d0f8b2f0e9e13aa3532a7e0314: Ensure captured variables in lambdas conform to the required Move abilities for the closure and that abilities are not missing.
// aa0ee9e75218a1cf57f5d03286c31b3b: Abort execution using the 'abort' statement
// b612228231af0ec395407363e8b1cefc: Set function body with a block of code representing the function's implementation.
