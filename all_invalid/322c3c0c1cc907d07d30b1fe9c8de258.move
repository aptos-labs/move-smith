//# publish
module 0x1::TestModule {
    // Public function that can be invoked to test access and conditional processing
    public fun process_value(val: u64): u64 {
        // For simplicity, just return the input value multiplied by 2
        val * 2
    }
}

module 0x2::ConditionalModule {
    // Function to demonstrate processing based on address
    public fun process_address(addr: address): bool {
        // Return true if address equals 0x3, false otherwise
        addr == 0x3
    }
}

module 0x4::NestedModule {
    // Nested module example
    module Inner {
        public fun inner_function(): u64 {
            42
        }
    }
}

//# run
script {
    // Empty script to compile and test module compilation
}

//# run 0x1::TestModule::process_value --args 10
//# run 0x2::ConditionalModule::process_address --args 0x3
//# run 0x4::NestedModule::Inner::inner_function

// To test processing definitions conditionally, include spec code
spec {
    // Define a variable 'x' with a value
    let x = 5u64;

    // Include module's function application
    include 0x1::TestModule;

    // Apply the process_value function with variable 'x'
    let result = apply 0x1::TestModule::process_value(x);
    // result should be 10

    // Test conditional processing based on address
    let addr = 0x3_address;
    include 0x2::ConditionalModule;

    // Apply process_address with address
    let is_target = apply 0x2::ConditionalModule::process_address(addr);
    // is_target should be true

    // Test nested module access with proper identifier
    include 0x4::NestedModule::Inner;

    // Call the inner function
    let nested_result = apply 0x4::NestedModule::Inner::inner_function();

    // Apply inner function without arguments
    // No assertions included as per instructions
}