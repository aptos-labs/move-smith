address 0xCAFE {
    
//# publish
    module DependentModule {
        public fun dep_function(a: u64, b: u64): u64 {
            a + b
        }

        public fun dep_lambda_runner() {
            // Move currently does not support lambda expressions (closures) or
            // stored function references like &fun(u8): u8.
            // To fix the code, we turn the lambda into a named function:
            // Instead of creating a lambda, just call the function directly.

            // Define an internal function to simulate the lambda:
            fun internal_lambda(x: u8): u8 {
                x * 10
            };
            let _ = internal_lambda(7u8);
        }
    }

    
//# publish
    module MainModule {
        use 0xCAFE::DependentModule;

        // lifted lambda stored as a function in global env
        public fun lifted_lambda(x: u8): u8 {
            x + 42
        }

        public fun use_dep_function_and_lambda(x: u64, y: u64, z: u8): u64 {
            let sum = DependentModule::dep_function(x, y);
            // call lifted lambda
            let plus_42 = Self::lifted_lambda(z);
            sum + (plus_42 as u64)
        }

        public fun runner() {
            let _ = Self::use_dep_function_and_lambda(10u64, 20u64, 2u8);
            DependentModule::dep_lambda_runner();
        }
    }
}


//# run 0xCAFE::MainModule::runner
