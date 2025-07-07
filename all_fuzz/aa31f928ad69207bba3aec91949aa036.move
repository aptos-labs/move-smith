
//# publish
module 0xCAFE::LambdaTest {
    use std::vector;

    // A function that defines and calls a lambda that adds two u64 values
    public fun add_lambda(x: u64, y: u64): u64 {
        let add = |a: u64, b: u64| { a + b };
        add(x, y)
    }

    // A function with a lambda that captures environment by copying a value
    public fun capture_lambda(): u8 {
        let fixed_val = 10u8;
        let multiply = |a: u8| { a * fixed_val };
        multiply(5u8)
    }

    // A unique function that uses lambda and returns a vector built inside lambda
    public fun vector_builder(): vector<u8> {
        let builder = || {
            let v = vector::empty<u8>();
            vector::push_back(&mut v, 42u8);
            vector::push_back(&mut v, 43u8);
            v
        };
        builder()
    }

    // Define a lambda inside a function that returns another lambda (closure like)
    public fun lambda_returner(): (|u8| u8) {
        let offset = 7u8;
        let lambda = |a: u8| { a + offset };
        lambda
    }

    // Call lambda_returner and then call returned lambda with an argument
    public fun test_lambda_returner(x: u8): u8 {
        let lambda = lambda_returner();
        lambda(x)
    }
}


//# run 0xCAFE::LambdaTest::add_lambda --args 4u64 5u64


//# run 0xCAFE::LambdaTest::capture_lambda


//# run 0xCAFE::LambdaTest::vector_builder


//# run 0xCAFE::LambdaTest::test_lambda_returner --args 8u8


// Featurres:
// 9d49e7a08362804957d46bd9b9c8f757: Rely on the Move compiler to infer 'acquires' annotations automatically for functions in language version V2_2 or newer; you may omit them as they are not strictly required.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 8c99c7b1eb1a5c9c78bd6d603f35c4d8: Define functions with unique names in the same module
