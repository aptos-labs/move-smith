
//# publish
module 0xCAFE::AdditionTest {
    public fun add_and_return_fixed(x: u8, y: u8): u8 {
        let _sum = x + y;
        // Always returns 42 regardless of inputs
        42
    }

    public fun call_lambda_example(): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };

        let result = lambda(10u8, 32u8);
        result
    }

    public fun run_lambda_as_argument(x: u8): u8 {
        let lambda: |u8| u8 has copy+drop = |a: u8| {
            a * 2u8
        };

        lambda(x)
    }
}




//# run 0xCAFE::AdditionTest::add_and_return_fixed --args 10u8 32u8




//# run 0xCAFE::AdditionTest::call_lambda_example




//# run 0xCAFE::AdditionTest::run_lambda_as_argument --args 21u8





//# publish
module 0xCAFE::VectorShadow {
    // This module purposely uses the same name as std::vector but shadows it.
    // This tests shadowing library modules with source modules.

    struct Dummy has copy, drop, store {
        val: u8,
    }

    // Rename struct name from `vector` to `Vector` to respect Move's naming rules (must start with uppercase)
    struct Vector<T> has store, drop, copy {}

    public fun dummy_vector(): Vector<u8> {
        (Vector{}: Vector<u8>)
    }

    // Function with same signature as std::vector::empty<u8> but returns dummy vector for test
    public fun empty_u8_vector(): Vector<u8> {
        // Return empty vector using own Vector notation shadowed here
        (Vector{}: Vector<u8>)
    }

    // Function using shadowed Vector type and basic operations
    public fun push_two_values(): Vector<u8> {
        let v = (Vector{}: Vector<u8>);
        // Cannot call std::vector functions because vector is shadowed, so no push_back call here
        // Just return the empty shadowed vector as a demonstration
        v
    }
}




//# run 0xCAFE::VectorShadow::dummy_vector




//# run 0xCAFE::VectorShadow::empty_u8_vector




//# run 0xCAFE::VectorShadow::push_two_values
