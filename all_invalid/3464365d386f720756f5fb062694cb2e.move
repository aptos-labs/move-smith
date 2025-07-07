
//# publish
module 0xCAFE::TestModule {
    use std::signer;
    use std::vector;

    // Function to demonstrate invocation with a named address
    public fun invoke_named_address(addr: address, x: u8): u8 {
        // Call a function on the given address
        // Here, we simulate calling another function as a nested call
        // Note: This would normally depend on imported modules, but for testing, we just mimic call
        // Since we're testing, we just return the value
        // In real tests, you'd call a specific function like `*address::Module::function`
        0
    }

    // Function to demonstrate use of wildcard address (represented as 'any' in comment)
    public fun call_with_any_address(addr: address, y: bool): u8 {
        // simulating calling a function at any address
        // This just uses provided address parameter
        if (y) {
            1
        } else {
            0
        }; 
    }

    // Function to view live variables at a specific point
    public fun live_variables_example() {
        let a: u8 = 5;
        let b: u8 = 10;
        let c: u8 = a + b;
        // At this point, live variables are: a, b, c
        // The test will check which variables are live at this point
        c
    }
}


//# run 0xCAFE::TestModule::invoke_named_address --args 0x1234u8
// This tests invoking a function at a specific address with arguments


//# run 0xCAFE::TestModule::call_with_any_address --args 0xAAAAu8 --signers 0x0 --args 0x1u8 true
// This tests calling with a wildcard (simulated via argument passing)


//# run 0xCAFE::TestModule::live_variables_example
// This test aims to verify which variables are live at the point of returning c

// Featurres:
// 87510c6f568e994b39a270b7aa41452c: Use a wildcard ('any') address specifier for flexible address matching.
// e0aab54c79f404bc763e4bcd3cd0821e: Invoke a named address with arguments as a call, like (SomeAddress()(argument)).
// 4a6bff41920ddd55c5486d32e639f7aa: View which local variables are live at a specific point in a function during compilation.
