
//# publish
module 0xCAFE::LintAndControlFlow {
    use std::debug;

    public fun lint_and_flow_tests(): u64 {
        // Nested if-else with nested loop
        let count = 0u64;
        if (true) {
            if (false) {
                count = 100;
            } else {
                let i = 0;
                while (i < 3) {
                    if (i == 1) {
                        count = count + 10;
                    } else {
                        count = count + 1;
                    };
                    i = i + 1;
                };
            };
        } else {
            count = 42;
        };

        // Nested loop with break and continue
        let outer = 0u64;
        while (outer < 3) {
            let inner = 0u64;
            loop {
                if (inner == 2) {
                    break;
                };
                if (inner == 1) {
                    inner = inner + 1;
                    continue;
                };
                outer = outer + 1;
                inner = inner + 1;
            };
            outer = outer + 1;
        };

        // This will be a large number to check correctness
        assert!(count < 1000, 1234);
        count
    }

    public fun assert_abort_test(should_abort: bool) {
        if (should_abort) {
            assert!(false, 0xDEAD);
        } else {
            assert!(true, 0xBEEF);
        };
    }

    native public fun native_function_example(val: u64): u64;
}


//# run 0xCAFE::LintAndControlFlow::lint_and_flow_tests


//# run 0xCAFE::LintAndControlFlow::assert_abort_test --args false


//# run 0xCAFE::LintAndControlFlow::native_function_example --args 123u64


// Featurres:
// 59c54d46170e9b9dac4684b0ec0a59d0: Allow function bodies to be checked by a variety of lint passes for code quality or correctness.
// 5dc7b10ab8ce70de1fbc5d73bd009bb4: Test that the Move language correctly handles nested loop and conditional expressions, and that the assert! macro causes script aborts as expected.
// 08a524881f316af14fd321de5686a158: Specify the visibility (public, script, etc.) of a native function.
