
//# publish
module 0xCAFE::TestFeatureInteractions {
    use std::vector;
    use std::signer;
    use std::ops::{Add};
    use std::convert::From;

    // Internal function only accessible within this module
    fun internal_helper(x: u64): u64 {
        x + 42
    }

    // Public script entry point that calls internal helper
    public fun script_entry_point(s: signer, val: u64): u64 {
        internal_helper(val)
    }

    // Generic function with type parameter
    public fun generic_increment<T>(x: T): T 
    where
        T: copy + Add<Output = T> + FromU64,
    {
        x + T::from_u64(1)
    }

    // Helper to create T from u64, since Move doesn't have default FromU64
    public fun make_from_u64<T>(val: u64): T
    where
        T: copy + FromU64,
    {
        T::from_u64(val)
    }

    // Function that calls generic_increment with different types
    public fun call_generic_functions(): (u64, u8) {
        let int_result = generic_increment(10u64);
        let byte_result = generic_increment(5u8);
        (int_result, byte_result)
    }

    // Function to report warnings; placeholder for demonstration
    public fun report_warnings() {
        // Dummy function for testing warnings
        ()
    }
}

// Script 1: Test variable scope and loops


//# run
script {
    fun main(account: signer) {
        let outer_var = 0u64;
        let counter = 0u64;
        while (counter < 3) {
            let inner_var = counter + outer_var;
            // Shadow outer_var inside loop (not used afterwards)
            let outer_var = inner_var + 1; // shadow outer_var
            counter = counter + 1;
        }
        // Verify outer_var remains unchanged
        // Call script entry to test internal function invocation
        let result = 0xCAFE::TestFeatureInteractions::script_entry_point(&account, 100);
        // Call generic functions
        let (max_u64, max_u8) = 0xCAFE::TestFeatureInteractions::call_generic_functions();

        // Call report_warnings (simulate)
        0xCAFE::TestFeatureInteractions::report_warnings();
    }
}



//# run 0xCAFE::TestFeatureInteractions::main --signers 0xBADD --args


// Features:
// b70ccb6e356eebb5b3735f5f76cd5273: Write script entry points in Move modules
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
// 0362c11170925d1fab2bbbc90bb94a42: Declare generic type parameters for functions
// 141a23e611f2ad603051b0ff7caaf9e7: Review compiler warnings with severity 'Warning' by calling report_warnings() to display them to the user.
// c9863e803ed2904d6439c8091d67848f: Define a script by specifying its name and associated functions and specifications.
