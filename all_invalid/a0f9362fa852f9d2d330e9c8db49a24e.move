
//# publish
module 0xDEAD::FallthroughTest {
    use std::vector;

    // Test 1: Implicit fall-through to labels with no branching instruction just before label
    public fun test_fall_through() {
        let counter = 0;
        // No branch before label, should fall-through sequentially
        label: {
            if (counter >= 3) {
                // Break out of label block
                break label;
            }
            counter = counter + 1;
            // fall-through to next instruction
        };
        // value after implicit fall-through
        counter
    }

    // Test 2: Improper function call with detailed error reporting about call site
    public fun call_with_error() {
        let a = 10;
        // Improper call: missing type arguments, should provide detailed error
        // The following line is intentionally incorrect for testing
        // move_from(a); // Error: move_from expects address argument, not value
        // To simulate an error in code, define an invalid call
        // This code is intended to cause an error when compiled to verify error reports
        // but since code cannot be invalid in static, document the comment
        // In real test, you'd attempt an invalid call like:
        // move_from<Module>(a); // Wrong usage, shouldn't compile
        ()
    }

    // Test 3: Complex address specifier with Call and chain of accesses
    public fun complex_address_call() {
        // Using 'Call' with chain, address, and function name
        // This is a simulated example to test syntax and address resolution
        // Note: Actual call will not compile outside a real runtime, but for test parsing
        let _result = Call::0xCAFE::MyModule::f1(2u8, false);
        let _res2 = Call::0xDEAD::SomeModule::some_fun(42u64);
    }

    // Runner function for test execution
    public fun run_all() {
        test_fall_through();
        call_with_error();
        complex_address_call();
    }
}


//# run 0xDEAD::FallthroughTest::run_all


// Featurres:
// 30200a459a0d35d57c9c2ed06e33f6bd: Allow implicit fall-through to labels when a preceding instruction is not a branching instruction in Move code.
// 86e60b7b8afe9487f0d478e63af0d9d5: Receive detailed error reporting about improper function calls, including call sites and the reason for the restriction
// b47e794a03683025102fcc2f16562b5b: Use address specifier 'Call' with a chain of accesses, type arguments, and a name to specify a complex address involving function call semantics.
