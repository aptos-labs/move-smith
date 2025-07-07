

//# publish
module 0xCAFE::TestModule {
    // Function to be used as an inline lambda, returns the doubled value
    public fun double(x: u64): u64 {
        x * 2
    }

    // Higher-order function that takes a function argument and a vector of u64s
    public fun apply_and_return(vec: vector<u64>, f: fun(u64): u64): vector<u64> {
        let result_vec = vector::empty<u64>();
        let len = vector::length(&vec);
        let i = 0;
        while (i < len) {
            let val = *vector::borrow(&vec, i);
            // apply the function 'f' to 'val'
            let new_val = f(val);
            vector::push_back(&mut result_vec, new_val);
            i = i + 1;
        }
        result_vec
    }

    // Function returning a lambda as a value, for higher-order functions
    public fun return_lambda(): fun(u64): u64 {
        // Move does not support returning functions directly, so just return double for testing.
        // In real, would design differently.
        double
    }
}

////// Test Section - scripts



//# run
script {
    use 0xCAFE::TestModule;
    use 0x1::vector; // explicitly import vector module

    fun main() {
        // Create a vector for testing
        let input_vec = vector::empty<u64>();
        vector::push_back(&mut input_vec, 10);
        vector::push_back(&mut input_vec, 20);
        vector::push_back(&mut input_vec, 30);

        // Use 'apply_and_return' with inline lambda 'double'
        let result_vec = TestModule::apply_and_return(input_vec, TestModule::double);

        // Create local parameter and return value for debugging
        let local_input = result_vec;
        // For debugging, store local_input in global storage or just leave here
        // In this test, just end after processing
    }
}


//# run 0xCAFE::TestModule::main

// Featurres:
// 03e80c4155cfc0aaa8b571fc2881b8a6: Identify primary target modules for linting
// 91cc7e7428dc741e1a77399d225956a6: Test that higher-order functions with inline lambdas can be used as arguments and return values within other higher-order function calls.
// 27c1a295b88bbd679e4eeae8497a24eb: Create local names for parameters and return values for debugging and introspection.
