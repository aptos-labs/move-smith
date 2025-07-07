//# publish
module 0xCAFE::VisibilityAndScopeTests {
    use std::signer;

    // An internal constant
    const INTERNAL_CONST: u64 = 42;

    // Public constant
    public const EXTERNAL_CONST: u64 = 100;

    // Internal function
    fun internal_add(x: u64, y: u64): u64 {
        x + y
    }

    // Public function that exposes internal
    public fun exposed_add(x: u64, y: u64): u64 {
        internal_add(x, y)
    }

    // Script entry point to test internal function via public wrapper
    public fun run_internal_add(x: u64, y: u64): u64 {
        exposed_add(x, y)
    }
}

//# run 0xCAFE::VisibilityAndScopeTests::run_internal_add --args 10u64 20u64


//# publish
module 0xCAFE::ScopeAndVariableHandling {
    use std::signer;

    public fun script_entry_point(s: signer) {
        // Declare local variable
        let inner_var: u64 = 5;
        // Initialize outer variable
        let outer_var: u64 = 5;

        // Start of while loop
        let i: u64 = 0;
        while (i < 3) {
            // Shadowed variable inside the loop
            let outer_var: u64 = i * 10;

            // Assignments inside loop
            inner_var = inner_var + outer_var;

            // Increment i
            i = i + 1;
        };
        // Return inner_var for verification if needed
        inner_var
    }

    // Function to test variable shadowing outside loop
    public fun test_shadowing(): u64 {
        let value: u64 = 8;
        let value: u64 = value + 2; // shadowing inner 'value'
        // The outer 'value' should be 10
        value
    }
}

//# run 0xCAFE::ScopeAndVariableHandling::script_entry_point --signers 0xBEEF

//# run 0xCAFE::ScopeAndVariableHandling::test_shadowing


//# publish
module 0xCAFE::VisibilityRestrictions {
    use std::signer;

    // Internal function
    fun internal_compute(x: u64): u64 {
        x * 2
    }

    // Public function calling internal function
    public fun call_internal(s: signer, x: u64): u64 {
        internal_compute(x)
    }

    // Attempt to access internal function from outside (should be invalid, just for completeness)
    // This code is for illustration; actual attempts should give compiler error if uncommented.
    // public fun external_access(): u64 {
    //     internal_compute(5) // should not compile
    // }
}

//# run 0xCAFE::VisibilityRestrictions::call_internal --signers 0xBEEF --args 7u64

//# run 0xCAFE::VisibilityRestrictions::external_access // This should be a comment: can't compile or run


//# publish
module 0xCAFE::ConstantsAccess {
    // Constants (no visibility modifier, so internal)
    const INTERNAL_ONLY: u64 = 555;

    // Public constant
    public const PUBLIC_CONST: u64 = 999;

    // Public function to access internal constant
    public fun get_internal_constant(): u64 {
        INTERNAL_ONLY
    }
}

//# run 0xCAFE::ConstantsAccess::get_internal_constant

//# run 0xCAFE::ConstantsAccess::get_external_const --args

// Main script to invoke all above functions and verify isolation

//# run 0xCAFE::VisibilityAndScopeTests::run_internal_add --args 15u64 27u64

//# run 0xCAFE::ScopeAndVariableHandling::script_entry_point --signers 0xBEEF

//# run 0xCAFE::ScopeAndVariableHandling::test_shadowing

//# run 0xCAFE::VisibilityRestrictions::call_internal --signers 0xBEEF --args 11u64

//# run 0xCAFE::ConstantsAccess::get_internal_constant

//# run 0xCAFE::ConstantsAccess::get_external_const
