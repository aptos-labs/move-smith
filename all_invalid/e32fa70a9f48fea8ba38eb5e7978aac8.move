module 0xABCD::TestModule {
    use std::vector;
    use std::signer;

    // 1. Declare a literal address specifier with a byte sequence using a number value
    const TEST_ADDRESS: address = (0x1234);
    
    // Helper function substituting the inline functions removed after inlining
    public fun dummy_func() {
        // This function is just to act as a placeholder for testing
        // Inlining is supposed to remove inline functions
        assert!(true, 0);
    }
}


//# run 0xABCD::TestModule::dummy_func



//# publish
module 0xABCD::TypeTester {
    use std::vector;

    // 3. Define tuple types with multiple types
    public fun create_tuple():(u64, bool) {
        (42, true)
    }

    public fun use_tuple(t: (u64, bool)): u64 {
        let (val, flag) = t;
        if (flag) {
            val + 1
        } else {
            val
        }
    }

    // Additional function to test tuple syntax with single element
    public fun single_element_tuple(): (u64) {
        (99)
    }
}


//# run 0xABCD::TypeTester::create_tuple



//# run 0xABCD::TypeTester::use_tuple --args (41, true)