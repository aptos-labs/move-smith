//# publish
module 0xCAFE::test_module {
    // Function to call lambdas and function pointers
    public fun call_lambda_and_function_pointer() {
        // Define a lambda that adds two u64 numbers
        let add_lambda: fun(a: u64, b: u64): u64 = 
            // Move the lambda into a variable of function type
            fun(a: u64, b: u64): u64 {
                a + b
            };
        // Call the lambda using ExpCall (explicit call)
        let result1 = add_lambda(10, 20);
        // Call the lambda using Call (function pointer)
        let lambda_ref = &add_lambda;
        let result2 = (*lambda_ref)(30, 40);

        // Define a normal function
        fun multiply(a: u64, b: u64): u64 {
            a * b
        }

        // Call normal function
        let result3 = multiply(3, 4);
    }
}

//# run 0xCAFE::test_module::call_lambda_and_function_pointer

//# publish
module 0xCAFE::vector_tests {
    use std::vector;

    // Function to create vectors with type parameters
    public fun create_vectors() {
        // Create a vector of u8 with initial elements
        let mut vec_u8 = vector::empty<u8>();
        vector::push_back(&mut vec_u8, 1u8);
        vector::push_back(&mut vec_u8, 2u8);
        vector::push_back(&mut vec_u8, 3u8);

        // Create a vector of u64 with initial elements
        let mut vec_u64 = vector::empty<u64>();
        vector::push_back(&mut vec_u64, 100);
        vector::push_back(&mut vec_u64, 200);
        vector::push_back(&mut vec_u64, 300);

        // Focus on primitives for simplicity
    }
}

//# run 0xCAFE::vector_tests::create_vectors

//# publish
module 0xCAFE::preccedence_tests {
    // Function to get the precedence level of binary operators
    public fun get_precedence(op: u8): u8 {
        // Define some operator tokens with arbitrary byte values
        // For simplicity, assume:
        // 1: '+' 
        // 2: '*' 
        // 3: '||'
        // 4: '&&'
        // The function returns precedence: higher number => higher precedence
        if (op == 2u8) {
            3 // '*' has higher precedence
        } else if (op == 1u8) {
            2 // '+' lower precedence
        } else if (op == 4u8) {
            1 // '&&' lower than '+'
        } else if (op == 3u8) {
            4 // '||' lower than '&&'
        } else {
            0 // unknown operator
        }
    }
}

//# run 0xCAFE::preccedence_tests::get_precedence