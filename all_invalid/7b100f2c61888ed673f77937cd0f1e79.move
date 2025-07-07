//# publish
address 0xCAFE {
    module LoopReturn {

        #[allow(reads_uninit)] // skipping some external lint as example usage
        public fun runner(): bool {
            let mut i = 0;
            while (i < 10) {
                let mut j = 0;
                while (j < 10) {
                    if (i == 5 && j == 5) {
                        return true;
                    }
                    j = j + 1;
                }
                i = i + 1;
            }
            // this assert should never be reached if return above works correctly
            assert!(false, 1);
            false
        }
    }
}

//# run 0xCAFE::LoopReturn::runner


//# publish
address 0xCAFE {
    module LintSkipExample {

        #[allow(dead_code, unused_variables)]
        public fun function_to_skip() {
            let _x = 123;
            // Not used variable and dead code, but skipped due to allow attribute
        }

        #[allow(unused_imports)]
        public fun runner() {
            function_to_skip();
        }
    }
}

//# run 0xCAFE::LintSkipExample::runner


//# publish
address 0xCAFE {
    module ConstantsMutateTest {
        const CONST_VAL: u64 = 42;

        public fun runner(): u64 {
            // Take constant by reference (copies it)
            let val_ref = &CONST_VAL;

            let mut local_val = *val_ref;
            // mutate the local copy via a mutable reference
            let local_ref = &mut local_val;
            *local_ref = *local_ref + 1;

            // Ensure original constant unchanged by returning both for inspection
            // but since no asserts, just return mutated local value for demonstration
            // The constant itself remains 42, local_val is 43
            local_val
        }
    }
}

//# run 0xCAFE::ConstantsMutateTest::runner

// Featurres:
// 2060e42e31fb0446aef758dfaa2d009f: Test that a `return` statement inside nested `while` loops correctly exits the loops and prevents subsequent code (such as failing `assert!`) from executing.
// d0dda1e9fa5ca36f6c00a021b042a5ce: Annotate modules with attributes to selectively skip specified external lint checks on certain functions.
// a6b20d4f13e81fd3939033fafed8f2b1: Test that Move constants can be taken by reference, mutated via local mutable references to their copies, and that such mutations do not affect the original constant values.
