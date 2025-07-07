
//# publish
module 0xCAFE::OperationsTest {
    use std::vector;

    // Test comparision, logical, bitwise and numerical operations on primitives and vectors
    public fun test_primitives_ops(): bool {
        let b1 = true;
        let b2 = false;

        let eq = (b1 == b1);
        let neq = (b1 != b2);
        let and_op = (b1 && b2);
        let or_op = (b1 || b2);
        let not_op = !b2;

        let u8_a: u8 = 5;
        let u8_b: u8 = 10;
        let add = u8_a + u8_b;
        let sub = u8_b - u8_a;
        let mul = u8_a * u8_b;
        let div = u8_b / u8_a;
        let mod_ = u8_b % u8_a;

        let bit_and = u8_a & u8_b;
        let bit_or = u8_a | u8_b;
        let bit_xor = u8_a ^ u8_b;
        let bit_not = !u8_a;

        let v1 = vector[1u8, 2u8, 3u8];
        let v2 = vector[1u8, 2u8, 3u8];
        let v3 = vector[4u8, 5u8, 6u8];

        let eq_vectors = vector::length(&v1) == vector::length(&v2);
        let neq_vectors = vector::length(&v1) != vector::length(&v3);

        eq && neq && not_op && (add == 15u8) && (mod_ == 0u8) && eq_vectors && neq_vectors
    }

    // Test binding mechanism with pattern matching and option-like style handling
    public fun test_binding_option_style(a: u8): u8 {
        // Emulating optional value with pattern binding
        let x = if (a > 5) { 10u8 } else { 0u8 };
        if (x > 0) {
            // bind pattern variable (simulate optional Some binding)
            let value = x;
            value
        } else {
            // optional None path uses default 42
            42u8
        }
    }

    // Demonstrate declaration of variables with and without initialization (locals only, since globals must be initialized)
    public fun test_var_declaration(): u8 {
        // Local declared without explicit initialization must be given before use in Move, 
        // so we optionally initialize here for demonstration
        let a: u8;
        let initialized = true;
        if (initialized) {
            a = 1u8;
        } else {
            a = 2u8;
        };
        let b: u8 = 3u8;
        a + b
    }

}


//# run 0xCAFE::OperationsTest::test_primitives_ops


//# run 0xCAFE::OperationsTest::test_binding_option_style --args 4u8


//# run 0xCAFE::OperationsTest::test_binding_option_style --args 6u8


//# run 0xCAFE::OperationsTest::test_var_declaration


// Featurres:
// 865cb079e5af2fe3e29a6af9a9639ece: Test the correctness of equality, inequality, logical, bitwise, and numeric operations on various primitive types and vectors.
// 28f6378e8f1499a048358d41b4c775c9: Utilize the binding mechanism to handle optional conversion results when translating pattern bindings.
// d0cd78814514a0cf6437adc60d8328c0: Declare global or local variables with optional initialization
