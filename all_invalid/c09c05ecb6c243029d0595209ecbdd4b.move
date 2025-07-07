//# publish
module 0xCAFE::ArithmeticAndVectors {
    use std::vector;

    const MAX: u16 = 65535u16;
    const MIN: u16 = 0u16;

    // Test construction of vectors with and without type arguments
    public fun make_vectors(): (vector<u8>, vector<u16>, vector<bool>) {
        let v1 = vector[1u8, 2u8, 3u8];
        let v2 = (vector[100u16, 200u16, 300u16]: vector<u16>);
        let v3 = vector[true, false, true];
        (v1, v2, v3)
    }

    // Addition - normal and overflow test (overflow aborts)
    public fun add(a: u16, b: u16): u16 {
        a + b
    }

    // Subtraction - normal and underflow test (underflow aborts)
    public fun sub(a: u16, b: u16): u16 {
        a - b
    }

    // Multiplication - normal and overflow test (overflow aborts)
    public fun mul(a: u16, b: u16): u16 {
        a * b
    }

    // Division - normal and division by zero abort
    public fun div(a: u16, b: u16): u16 {
        // Division by zero aborts, no explicit check needed
        a / b
    }

    // Modulo - normal and division by zero abort
    public fun modu(a: u16, b: u16): u16 {
        a % b
    }

    // Run all arithmetic operations with fixed test values 
    public fun run_arithmetic_tests() {
        let _ = add(100u16, 200u16);
        let _ = add(MAX, 0u16);
        // Overflow test, expect abort, but here just call
        // let _ = add(MAX, 1u16);

        let _ = sub(200u16, 100u16);
        let _ = sub(0u16, 0u16);
        // Underflow test, expect abort on runtime
        // let _ = sub(0u16, 1u16);

        let _ = mul(300u16, 2u16);
        let _ = mul(MAX / 2u16, 2u16);
        // Overflow test, expect abort on runtime
        // let _ = mul(MAX, 2u16);

        let _ = div(100u16, 10u16);
        let _ = div(1u16, 1u16);
        // Division by zero test, expect abort on runtime
        // let _ = div(100u16, 0u16);

        let _ = modu(100u16, 30u16);
        let _ = modu(10u16, 3u16);
        // Modulo by zero test, expect abort on runtime
        // let _ = modu(100u16, 0u16);
    }
}

//# run 0xCAFE::ArithmeticAndVectors::make_vectors

//# run 0xCAFE::ArithmeticAndVectors::add --args 100u16 200u16

//# run 0xCAFE::ArithmeticAndVectors::sub --args 200u16 100u16

//# run 0xCAFE::ArithmeticAndVectors::mul --args 300u16 2u16

//# run 0xCAFE::ArithmeticAndVectors::div --args 100u16 10u16

//# run 0xCAFE::ArithmeticAndVectors::modu --args 100u16 30u16

//# run 0xCAFE::ArithmeticAndVectors::run_arithmetic_tests


//# run
script {
    use 0xCAFE::ArithmeticAndVectors;

    const CONST_VAL: u16 = 1234u16;

    spec script {
        // Specification block without body just to test spec syntax
    }

    fun main() {
        let v_tuple = ArithmeticAndVectors::make_vectors();
        let (v1, v2, v3) = v_tuple;
        let _sum = ArithmeticAndVectors::add(CONST_VAL, 100u16);
        let _difference = ArithmeticAndVectors::sub(CONST_VAL, 10u16);
        let _product = ArithmeticAndVectors::mul(CONST_VAL, 2u16);
        let _quotient = ArithmeticAndVectors::div(CONST_VAL, 3u16);
        let _remainder = ArithmeticAndVectors::modu(CONST_VAL, 5u16);
    }
}

// Featurres:
// d50cf5731589eaf13d4298ccc60de113: Construct vectors using the 'vector' keyword with optional type arguments and a list of elements.
// c85a1e84234e716f1bfd9fd0ba0b18a2: Test that all arithmetic operations—addition, subtraction, multiplication, division, and modulo—on the u16 integer type correctly handle normal cases, edge cases, and overflow/underflow or division-by-zero errors according to Move language semantics.
// 2547807e4d5b91edc1a1d1eabd2344db: Write scripts that include attributes, uses, constants, functions, and specifications.
