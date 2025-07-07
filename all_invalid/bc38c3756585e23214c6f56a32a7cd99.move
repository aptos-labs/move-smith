//# publish
module 0xA550C3E33F8A7D6E::TestModule {
    // Struct with optional visibility modifier
    // Assume language v2 features are enabled for visibility modifiers
    // (In actual Move, visibility modifiers are a language feature; for test, we simulate inclusion)
    public struct OptionalVisibility {
        value: u64,
    }

    // Function to test add2 and add3 calls
    public fun test(): u64 {
        let local_var = 10;
        let sum = Self::add2(local_var);
        let result = Self::add3(sum);
        result
    }

    fun add2(x: u64): u64 {
        x + 2
    }

    fun add3(y: u64): u64 {
        y + 3
    }

    // Runner function
    public fun run_tests() {
        let result = Self::test();
        // No assertions, just ensure calls work
    }
}

//# run 0xA550C3E33F8A7D6E::TestModule::run_tests

//# publish
module 0xA550C3E33F8A7D6E::VectorTest {
    // Function to create vectors with specified element type and elements
    public fun create_vectors() {
        // Vector of u8 with elements 1, 2, 3
        let vec_u8 = vector<u8>[1, 2, 3];

        // Vector of u64 with elements 10, 20, 30
        let vec_u64 = vector<u64>[10, 20, 30];

        // Vector of boolean with elements true, false
        let vec_bool = vector<bool>[true, false];

        // Vector of address with elements 0x1, 0x2
        let vec_addr = vector<address>[0x1, 0x2];

        // Vector of strings - Move does not support string literals,
        // but for test, assume symbol or similar
        // Alternatively, omit strings if unsupported
    }
}