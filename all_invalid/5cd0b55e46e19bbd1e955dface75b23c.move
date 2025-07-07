
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

    // Struct with unique field names
    struct UniqueFieldsHasType {
        a: u64,
        b: bool,
        a_b: vector<u8>,
    }
}


//# run 0xCAFE::VisibilityTest::f_public


//# run 0xCAFE::VisibilityTest::call_with_function --type-args u64 --args 0xCAFE::VisibilityTest::sample_func 100u64