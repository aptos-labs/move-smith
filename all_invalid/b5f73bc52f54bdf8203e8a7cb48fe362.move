//# publish
module 0xCAFE::FeatureValidation {
    use std::signer;

    // Function to test nested control flow with if-continue inside a loop
    public fun nested_control_flow_test(limit: u8): u8 {
        let i = 0u8;
        let sum = 0u8;
        while (i < limit) {
            if (i % 2 == 0) {
                i = i + 1;
                continue;
            }
            if (i >= 10) {
                break;
            }
            sum = sum + i;
            i = i + 1;
        };
        sum
    }

    // Function to call an impure function inside a spec expression (should produce an error)
    public fun impure_call_in_spec() {
        // Pure functions only allowed in specifications.
        // Attempting to call a function with side effects should cause an error.
        // The following line is intentionally invalid:
        // assert!(self.impure_func() == 1, 999);
        // Because this is a test, we write a dummy to represent the attempt.
        // Note: In actual code, this would cause the compiler error.
        // assert!(self.impure_func() == 1, 999);
    }

    // Dummy impure helper function
    public fun impure_func(): u64 {
        // Side-effect inducing function (e.g., reading global state), for test purpose
        42
    }

    // Nested module with fields
//# publish
    module 0xCAFE::NestedModule {
        struct InnerStruct has copy, drop, store {
            value: u64
        }

        public fun get_inner_value() : u64 {
            let inner_instance = InnerStruct { value: 12345 };
            inner_instance.value
        }
    }

    // Access nested module's struct field
    public fun chain_access_test() : u64 {
        // Call function to get the value
        0xCAFE::NestedModule::get_inner_value()
    }

    // Declare local variables, assign, and perform summation
    public fun variable_sum(a: u64, b: u64): u64 {
        let total = 0u64;
        let x = a; // local variable
        let y = b; // local variable
        total = total + x;
        total = total + y;
        total
    }

    // Function accepting parameters with abilities like 'has drop' and operating on them
    public fun accept_drop_and_sum(x: vector<u8>, y: vector<u8>): vector<u8> {
        // Create mutable copies by cloning
        let result = x;
        vector::append(&mut result, &y);
        result
    }
}


//# run 0xCAFE::FeatureValidation::nested_control_flow_test --args 15u8

//# run 0xCAFE::FeatureValidation::impure_call_in_spec

//# run 0xCAFE::FeatureValidation::chain_access_test

//# run 0xCAFE::FeatureValidation::variable_sum --args 10u64 20u64

//# run 0xCAFE::FeatureValidation::accept_drop_and_sum --args b"hello" b"world"
