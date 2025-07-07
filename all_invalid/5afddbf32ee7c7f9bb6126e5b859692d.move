
//# publish
module 0xCAFE::TestConstants {
    // Utility to generate large vectors for testing
    public fun generate_large_vector(): vector<u8> {
        let vec = vector::empty<u8>();
        let size = 900; // large vector size
        let i = 0;
        while (i < size) {
            vector::push_back(&mut vec, (i as u8));
            i = i + 1;
        }
        vec
    }

    // Function to compare two large vectors efficiently
    public fun vectors_equal(v1: &vector<u8>, v2: &vector<u8>): bool {
        let len1 = vector::length(v1);
        let len2 = vector::length(v2);
        if (len1 != len2) {
            return false;
        }
        let i = 0;
        while (i < len1) {
            if (*vector::borrow(v1, i) != *vector::borrow(v2, i)) {
                return false;
            }
            i = i + 1;
        }
        true
    }
}


//# run
script {
    use 0xCAFE::TestConstants;

    fun main() {
        // Generate two large vectors
        let vec1 = TestConstants::generate_large_vector();
        let vec2 = TestConstants::generate_large_vector();

        // Compare large vectors for equality
        let are_equal = TestConstants::vectors_equal(&vec1, &vec2);
    }
}

//# run 0xCAFE::TestConstants::main


//# publish
module 0xCAFE::MultiReturn {
    // Function with multiple return values
    public fun multi_return(a: u64, b: u64): (u64, u128) {
        let sum = a + b;
        let product = (a as u128) * (b as u128);
        (sum, product)
    }
}


//# run
script {
    use 0xCAFE::MultiReturn;

    fun main() {
        let (sum, product) = MultiReturn::multi_return(10, 20);
    }
}

//# run 0xCAFE::MultiReturn::main


//# publish
module 0xCAFE::LambdaTest {
    // Function with lambda capturing and optional move or copy
    public fun execute_lambda() {
        let x = 42;
        let y = 100;

        // Lambda with move capture
        let lambda_move = |z: u8| {
            // use captured variables
            let temp = x + y + (z as u64);
            temp
        };

        // Lambda with copy capture (primitive types are copy by default)
        let lambda_copy = |z: u8| {
            let temp = x + y + (z as u64);
            temp
        };

        // Call lambdas
        let _result_move = lambda_move(10);
        let _result_copy = lambda_copy(20);
    }
}


//# run
script {
    use 0xCAFE::LambdaTest;

    fun main() {
        LambdaTest::execute_lambda();
    }
}

//# run 0xCAFE::LambdaTest::main

// Featurres:
// 4a4fdcd953931b14d0f46289445e9339: Test that the Move compiler can handle constant expressions involving equality comparison of very large vectors (e.g., vectors of over 800 elements).
// 39a5276d71bb4576631a14e3c7dab09f: Support functions with multiple return values by generating appropriate result temporaries and labels.
// d91206d30c35a2d17e37741713c131b1: Write lambda expressions with optional move or copy capture kinds
