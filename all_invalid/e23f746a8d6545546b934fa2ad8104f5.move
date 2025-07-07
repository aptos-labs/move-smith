//# publish
module 0xDEADBEEF::InlineSpecModules {
    /// Create inline specification functions with the 'for_inline' parameter
    public fun inline_create_and_use() {
        let _ = inline_for_inline();
    }

    // This function is eligible for inline expansion
    public fun inline_for_inline(): u64 {
        42
    }

    /// Reference types mutably or immutably with 'Ref'
    // Function demonstrating immutable reference
    public fun use_immutable_ref(val: &u64): u64 {
        *val + 1
    }

    // Function demonstrating mutable reference
    public fun use_mutable_ref(val: &mut u64): u64 {
        *val = *val + 10;
        *val
    }
}

 //# publish
module 0xCAFEBABE::VisibilityTest {
    // Public function - accessible outside the module
    public fun public_func() {
    }

    // Friend function - accessible to modules designated as friends
    friend fun friend_func() {
    }

    // Private function - accessible only within this module
    private fun private_func() {
    }
}

 //# publish
module 0xFEEDFACE::Executor {
    // Runner function that exercises inline functions, references, and visibility
    public fun run_all() {
        // Call the inline_create_and_use function
        0xDEADBEEF::InlineSpecModules::inline_create_and_use();

        // Create a value to test references
        let mut value: u64 = 100;

        // Call the function with immutable reference
        let _ = 0xDEADBEEF::InlineSpecModules::use_immutable_ref(&value);

        // Call the function with mutable reference
        let new_value = 0xDEADBEEF::InlineSpecModules::use_mutable_ref(&mut value);
    }

    //# run 0xFEEDFACE::Executor::run_all
}