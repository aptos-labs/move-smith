
//# publish
module 0xCAFE::FeatureTest {
    use std::vector;

    // Specification block for formal verification
    spec {
        // Global spec variable
        global_var: u64; // Removed the '=' which is invalid syntax
        // Initialize or assign values elsewhere if needed
    }

    struct Stock has store, key {
        count: u64,
        name: vector<u8>,
    }

    // A function with a spec block, demonstrating spec variables
    public fun increment_counter(): u64 {
        // Spec block with local variables
        spec {
            let local_counter: u64; // Removed the '='
            // Initialize if needed
            // assign local_counter = 10;
        }

        let counter = 0;
        {
            // Assign a value via a complex expression
            let temp = {
                let a = 5;
                let b = 7;
                a + b
            };
            let &mut ref_counter = &mut counter;
            *ref_counter = temp + 10; // update the variable through a mutable reference
        };
        counter
    }

    // Function to test assignment to mutable reference from a complex expression
    public fun complex_ref_update(x: u64): u64 {
        // Create local variable
        let value = x; // 'value' must be mutable to be assigned
        // Complex expression returning a mutable reference
        let ref_to_value: &mut u64 = &mut {
            // Inside a block, update value
            {
                let increment = {
                    let a = 3;
                    let b = 4;
                    a * b
                };
                value = value + increment;
            };
            &mut value
        };
        // Update via reference
        *ref_to_value = *ref_to_value + 100;
        value
    }

    // Function with specification variables assigned via parameters
    public fun param_spec_test(a: u64, b: u64): u64 {
        spec {
            let spec_var: u64; // Removed '='
            // assign spec_var = a + b;
        }
        let sum = a + b;
        sum
    }

    // Function to demonstrate the correctness of assigning a variable from a complex expression
    public fun complex_assignment(): u64 {
        let x = 0; // 'x' should be mutable to assign
        x = {
            let temp1 = 2u64;
            let temp2 = 3u64;
            let sum = temp1 + temp2;
            sum * 10
        };
        x
    }

    // Function to update a mutable reference held in a local variable
    public fun update_via_ref(y: u64): u64 {
        let val = y; // 'val' should be mutable to modify via reference
        // get a mutable reference to val
        let ref_val: &mut u64 = &mut val;
        *ref_val = *ref_val + 55;
        val
    }
}



//# run 0xCAFE::FeatureTest::increment_counter --args


//# run 0xCAFE::FeatureTest::complex_ref_update --args 20


//# run 0xCAFE::FeatureTest::param_spec_test --args 15u64 25u64


//# run 0xCAFE::FeatureTest::complex_assignment --args


//# run 0xCAFE::FeatureTest::update_via_ref --args 77