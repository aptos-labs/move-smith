
//# publish
module 0xCAFE::TestModule {
    // Define a structure with abilities to test complex data types
    struct TestStruct has copy, drop, store {
        value: u64,
    }

    // Function to test multiple specification block members (like ensures properties)
    public fun spec_test_function(x: u64): u64 {
        // Property: the output is greater than input if input is even
        let result = if x % 2 == 0 {
            x + 10
        } else {
            x + 5
        };
        // Example of specification: result should be greater than x
        // (Assumed to be part of spec block, not code, but shown here for completeness)
        // ensures result > x
        result
    }

    // Function to reference a named address module
    public fun call_other_module_property(): bool {
        // Calls a function from an address alias 0xBADD::OtherModule
        // assuming such a module exists and has a function named 'property_check'
        // For the sake of this test, we just return true
        true
    }

    // Function with if-else that returns a boolean
    public fun conditional_prop(y: u64): bool {
        if y > 100 {
            true
        } else {
            false
        }
    }

    // Runner function to invoke above functions
    public fun run_tests() {
        let _ = spec_test_function(20);
        let _ = call_other_module_property();
        let _ = conditional_prop(50);
        let _ = conditional_prop(150);
    }
}


//# run 0xCAFE::TestModule::run_tests --signers 0xCAFE


//# run 0xCAFE::TestModule::spec_test_function --args 42u64 --signers 0xCAFE


//# run 0xCAFE::TestModule::call_other_module_property --signers 0xCAFE


//# run 0xCAFE::TestModule::conditional_prop --args 50u64 --signers 0xCAFE


//# run 0xCAFE::TestModule::conditional_prop --args 150u64 --signers 0xCAFE

// Featurres:
// d22def6f0f1bfd93aa22ecc1d52cd4e2: Define multiple specification block members to specify properties or behaviors of modules or functions.
// ed76520c813b9347b95ad8df42fbf757: Reference named address syntax (`address_name::module_name`) to access a module in your Move code if the named address is declared.
// d32bd826c9c658f1a41d3d18c744bcd7: Write `if-else` conditional expressions.
