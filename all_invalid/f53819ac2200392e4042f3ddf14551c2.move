//# publish
module 0xCAFE::nested_function_tests {
    use std::vector;
    use std::string;

    // Define a simple function that captures an external variable and performs addition
    public fun add_captured(captured_value: u64, x: u64): u64 {
        captured_value + x
    }

    // Define a higher-order function that takes a function and applies it to a value
    public fun apply_function(f: &fun(u64, u64): u64, value: u64): u64 {
        f(value, 5)
    }

    // Compose nested function calls with captures
    public fun nested_composition(): u64 {
        let base = 10;
        let add_fn = &add_captured;
        let result = apply_function(add_fn, base);
        result
    }

    // Function to test for loop iteration
    public fun test_loop(): vector<u64> {
        let vec = vector::empty<u64>();
        for i in 0..10 {
            vector::push_back(&mut vec, i);
        }
        vec
    }

    // Function to get full function name and address
    public fun test_get_full_name(): string::String {
        // Using the special function to get full name with address
        let full_name_addr = get_full_name_with_address();
        // Convert string to String object
        string::utf8(full_name_addr)
    }
}

////# run 0xCAFE::nested_function_tests::nested_composition --signers 0xCAFE
script {
    fun main() {
        let result = 0xCAFE::nested_function_tests::nested_composition();
        // Result should be 15 (10 + 5)
    }
}

//# // Testing the nested function composition
//# run 0xCAFE::nested_function_tests::test_loop --signers 0xCAFE
script {
    fun main() {
        let vec = 0xCAFE::nested_function_tests::test_loop();
        // vec should contain 0,1,2,...,9
    }
}

//# // Testing get_full_name_with_address() function
//# run 0xCAFE::nested_function_tests::test_get_full_name --signers 0xCAFE
script {
    fun main() {
        let name = 0xCAFE::nested_function_tests::test_get_full_name();
        // name contains the full name with address, e.g., "0xCAFE::nested_function_tests::test_get_full_name()"
        // No assertions, just test the function executes
    }
}

// Featurres:
// 193eac7d1e83e8ed9a345aa9b71f7f43: Test that nested function values with captured variables correctly perform arithmetic operations and that function composition with captures produces expected results.
// e30a10ad8f41ff841643f76465921990: Test that a for loop iterates correctly over a range from 0 to 10.
// c1aba2048db59a0b11e55b5fa11c213d: Use the `get_full_name_with_address()` method to obtain the full name and address of a function.
