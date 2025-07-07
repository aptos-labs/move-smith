
//# publish
module 0xCAFE::SpecFeatureTest {
    use std::vector;
    use std::debug;

    struct Counter has store {
        val: u64,
    }

    /// Struct to hold a lambda for demonstration
    struct LambdaHolder has store {
        func_id: u8, // just a dummy field to simulate a lifted lambda id
    }

    /// Spec function with explicit return type annotation
    spec fun spec_with_return_type(x: u64): u64 {
        x + 42
    }

    /// Spec function that tests a loop with immediate return to stop looping early
    spec fun loop_with_early_return(n: u64): u64 {
        let acc = 0;
        let i = 0;
        while (i < n) {
            if (i == 3) {
                return acc + 100;
            };
            acc = acc + i;
            i = i + 1;
        };
        acc
    }

    /// Spec function using a lambda; the lambda represents an anonymous function that will be lifted
    spec fun lambda_usage_in_spec(x: u64): u64 {
        // A lifted lambda function: adds 10 to input
        let lifted_lambda = (addr: address, y: u64): u64 => y + 10;

        lifted_lambda(@0xCAFE, x) + 5
    }

    /// Combined spec function: explicit return type, loop with immediate return and using a lambda
    spec fun combined_spec(x: u64): u64 {
        // Lifted lambda adds 2*x to input y
        let lifted_lambda = (addr: address, y: u64): u64 => {
            let r = y + 2 * x;
            r
        };

        let i = 0;
        let total = 0;
        while (i < 5) {
            if (i == 2) {
                return lifted_lambda(@0xCAFE, total);
            };
            total = total + i;
            i = i + 1;
        };
        lifted_lambda(@0xCAFE, total) + 1
    }

    /// Runner function to exercise spec functions inside a transaction (recognizes specs do not produce code but can be regression tested)
    public fun runner() {
        let _ = spec_with_return_type(10);
        let _ = loop_with_early_return(10);
        let _ = lambda_usage_in_spec(7);
        let _ = combined_spec(4);

        // Just debug prints to make the function non-empty and usable in transactional execution (not asserting)
        debug::print(&vector::empty<u8>());
    }
}


//# run 0xCAFE::SpecFeatureTest::runner --signers 0xBEEF


// Featurres:
// ba65b0a21cd5b5515b25dcf742939b68: Specify the return type of a spec function after a colon.
// b9112366c5a7b871a9e9fd4fe22553ad: Test that a loop with an immediate return inside its body correctly terminates execution.
// cd34022955ec70e2dd4dd01bc5be5352: Apply lambda lifting to function-level specifications to move lambdas out of annotations and specifications.
