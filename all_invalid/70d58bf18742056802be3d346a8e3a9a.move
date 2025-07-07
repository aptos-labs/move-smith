
//# publish
module 0xCAFE::Test_Module_Dereference_Unary {
    // Removed invalid use statement
    // use std::assert;

    // A simple dummy function to be called internally
    public fun internal_func(): u64 {
        42
    }

    // Function to test dereference and unary expressions with sub-expressions
    public fun test_dereference_unary(): u64 {
        let a: u64 = 10;
        let b: u64 = 20;
        let c: u64 = a + b; // addition as sub-expression
        let d: u64 = 5;

        // Unary expression: negation (simulate by subtraction from 0)
        let neg_c = 0 - c;

        // Create a vector and dereference
        let vec: vector<u8> = b"test";
        let first_byte = *vec.get(0); // dereference

        // Final expression combining unary and dereference
        let result = neg_c + (first_byte as u64);

        result
    }

    // Runner function to execute the test
    public fun run_tests(): u64 {
        test_dereference_unary()
    }
}



//# run 0xCAFE::Test_Module_Dereference_Unary::run_tests