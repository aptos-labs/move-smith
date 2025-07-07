
//# publish
module 0xCAFE::VisibilityTest {
    use std::vector;

    // Guard: Functions are public(script), should only be callable from scripts
    public(script) fun f_public_script() {
        // empty function body
    }

    // Guard: Function is public, accessible from other modules
    public fun f_public() {}

    // The following function is private and should NOT be called by scripts
    fun f_private() {}

    // Define a generic function type accepting a function as argument
    public fun call_with_function<T>(
        func: |T|: (T),
        arg: T
    ) {
        func(arg)
    }

    // Sample function to pass
    public fun sample_func(x: u64): u64 {
        x + 42
    }

    // Struct with duplicate field names, handled by renaming (field names need to be unique)
    struct UniqueFieldsHasType {
        a: u64,
        b: bool,
        a_b: vector<u8>,
    }
}


//# run 0xCAFE::VisibilityTest::f_public

//# run 0xCAFE::VisibilityTest::call_with_function --args 0xCAFE::VisibilityTest::sample_func 100u64
// Note: The following script will attempt to call a private function which should be disallowed by compiler rules. This is for testing purposes only and should error if enforced.

// Featurres:
// 5455ff75a13c9b6d4b39759d22407b1d: Restrict visibility of functions and modules to scripts using the 'public(script)' visibility modifier.
// e003a7dfb459df4e1f343a32890d3391: Define generic function types that accept functions as arguments.
// 8724f88c2ea37e4a139b3af7d6474e05: Declare struct fields with unique names and types, and handle duplicate field definitions properly.
