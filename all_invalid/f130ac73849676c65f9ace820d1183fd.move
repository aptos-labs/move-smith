// The test address is 0xCAFE

//# publish
address 0xCAFE {
    module GenericFnClosure {
        use std::signer;

        /// A generic inline function that accepts a closure which takes a reference to T and returns R.
        public inline fun apply_ref_generic<T, R, F>(x: &T, f: &F): R
        where F: copy + drop + store,
              F: Fn<&T, R> {
            // The function type alias Fn is a trait to be simulated by calling a function pointer:
            // Since Move doesn't support real traits, this example simulates passing a function reference.
            // We call the function on the reference.
            f(x)
        }

        /// Runner function for testing apply_ref_generic
        /// It creates an integer, passes a closure that dereferences and multiplies by 3,
        /// and returns the result.
        public fun run(): u64 {
            let val = 10u64;

            // Define a closure on the stack as a function pointer (simulated)
            // Since Move does not have real closures,
            // we simulate by passing a function reference declared below.
            apply_ref_generic(&val, &Self::lambda_mul3)
        }

        // Simulated closure function: takes &u64, returns u64 (x * 3).
        public inline fun lambda_mul3(x: &u64): u64 {
            *x * 3
        }
    }
}
//# run 0xCAFE::GenericFnClosure::run

//# publish
address 0xCAFE {
    module LambdaFuncTest {
        /// Inline lambda function simulation that takes a u64, adds 42, and returns u64.
        public inline fun inline_add_42(x: u64): u64 {
            x + 42
        }

        /// Runner function that applies inline_add_42 with argument 8 and returns result 50.
        public fun run(): u64 {
            inline_add_42(8)
        }
    }
}
//# run 0xCAFE::LambdaFuncTest::run


//# publish
address 0xCAFE {
    module LambdaLiftMarker {
        /// A function that simulates a lambda lifted function.
        /// The name contains the marker `__lambda_lifted_fun__` to identify it.
        public fun __lambda_lifted_fun__special(x: u64): u64 {
            x * x
        }

        /// Runner to call the lambda lifted function to exercise it.
        public fun run(): u64 {
            __lambda_lifted_fun__special(7)
        }
    }
}
//# run 0xCAFE::LambdaLiftMarker::run

//# run 0xCAFE::GenericFnClosure::lambda_mul3
//# run 0xCAFE::LambdaFuncTest::inline_add_42
//# run 0xCAFE::LambdaLiftMarker::__lambda_lifted_fun__special

// Featurres:
// 2b7c242bf6cecc00abda17f7565d11f5: Test that closures with references can be passed to and invoked from an inline generic function.
// 5f944ba3db860cb7c650085e0f872233: Test that an inline lambda function correctly applies its argument and returns the expected value.
// cef87b05b783ce31d7a329f3d6203a99: Identify functions that are the result of lambda lifting by checking for a specific marker in their name.
