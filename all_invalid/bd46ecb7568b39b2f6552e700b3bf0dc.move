//# publish
module 0x1::test_module {
    use std::vector;

    // Define a nested vector constant
    const NESTED_VECTOR: vector<vector<u8>> = vector[
        vector![1u8, 2u8],
        vector![3u8, 4u8]
    ];

    // Declare a constant referencing the nested vector
    const CONSTANT_VECTOR: &vector<vector<u8>> = &NESTED_VECTOR;

    // Function to perform a map over nested vectors with closure referencing outer variable
    public fun test_vector_map() {
        let outer_capture: u8 = 10;
        // Map over each inner vector, adding outer_capture to each element
        let result: vector<vector<u8>> = vector::map<vector<u8>, vector<u8>>(CONSTANT_VECTOR, |inner_vec: &vector<u8>| {
            vector::map<u8, u8>(inner_vec, |elem: &u8| {
                *elem + outer_capture
            })
        });
        // 'result' now contains nested vectors with each element incremented by 10
        // (In actual tests, you might assert or log results here)
    }

    // Function to simulate displaying local variable names (disambiguation)
    public fun test_symbol_pool_display() {
        let local_a: u64 = 42;
        let local_b: bool = true;
        let local_c: vector<u8> = b"hello";

        // Assign variable names explicitly for clarity
        let _a_name = "local_a";
        let _b_name = "local_b";
        let _c_name = "local_c";

        // The variables are used to simulate symbol pool info; no runtime effect
    }

    // Main test execution
    public fun main() {
        test_vector_map();
        test_symbol_pool_display();
    }
}
