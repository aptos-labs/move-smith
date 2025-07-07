
//# publish
module 0xCAFE::TestModule {
    // Test skipping lint checks with attributes
    #[skip(dead_code, unused_variables)]
    public fun skipped_attributes() {
        return;
    }

    // Helper function to invoke a closure with references
    public fun invoke_closure_with_refs<T>(
        closure: &fun(&T), 
        reference: &T
    ) {
        closure(reference);
    }

    // Inline generic function that accepts a closure
    public inline fun call_with_closure<T>(
        closure: &fun(&T),
        arg: &T
    ) {
        invoke_closure_with_refs(closure, arg);
    }
}



//# run 0xCAFE::TestModule::call_with_closure --signers 0xCAFE --args





//# publish
module 0xCAFE::TestFeatures {
    use 0xCAFE::TestModule;

    // Function to test closure invocation
    public fun test_closure() {
        let x = 42;
        // Define a closure that takes a reference and does nothing
        let closure = &fun(reference: &u8) {
            // do nothing or assert, just placeholder here
            // For Move, cannot print; just ensuring it's invokable
        };
        // Call the generic function with the closure and a reference
        TestModule::call_with_closure(closure, &x);
    }
}



//# run 0xCAFE::TestFeatures::test_closure --signers 0xCAFE

// Featurres:
// 85d70db24f0dfbddd45719cc1c118ad3: Avoid using unused alias declarations in your code to keep it clean and maintainable.
// 84c8cd1da70fe50076541bf9c4b58477: Annotate attributes with `#[skip(...)]` to specify lint checks to be skipped.
// 2b7c242bf6cecc00abda17f7565d11f5: Test that closures with references can be passed to and invoked from an inline generic function.
