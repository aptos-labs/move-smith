
//# publish
module 0xCAFE::AdditionModule {
    public fun add_and_return_fixed_value(x: u8, y: u8): u8 {
        let sum = x + y;
        if (sum > 10) {
            // no abort here, just an if statement
            42
        } else {
            7
        };
        99
    }

    public fun lambda_expression_usage(x: u8, y: u8): u8 {
        let sum_lambda: |u8, u8|u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        sum_lambda(x, y)
    }
}


//# run 0xCAFE::AdditionModule::add_and_return_fixed_value --args 3u8 4u8


//# run 0xCAFE::AdditionModule::lambda_expression_usage --args 5u8 6u8


//# publish
module 0xCAFE::InlineCaller {
    use 0xCAFE::AdditionModule;

    public inline fun inline_adder(a: u8, b: u8): u8 {
        AdditionModule::lambda_expression_usage(a, b)
    }

    public fun nested_call(a: u8, b: u8): u8 {
        inline_adder(a, b)
    }

    public fun test_abort_expr(x: u8, y: u8) {
        let sum = x + y;
        assert!(sum < 10, 1234);
    }
}


//# run 0xCAFE::InlineCaller::nested_call --args 1u8 2u8


//# run 0xCAFE::InlineCaller::test_abort_expr --args 5u8 4u8


//# publish
module 0xCAFE::VectorMapTest {
    use std::vector;

    public fun map_vector_primitive(input: vector<u8>): vector<u8> {
        vector::map<u8, u8>(input, |x: u8| { x + 1 })
    }

    public fun map_vector_of_vectors(input: vector<vector<u8>>): vector<vector<u8>> {
        vector::map<vector<u8>, vector<u8>>(input, |v: vector<u8>| {
            vector::map<u8, u8>(v, |x: u8| { x + 2 })
        })
    }

    public fun run_tests(): (vector<u8>, vector<vector<u8>>) {
        let primitive_vector = vector[1u8, 2u8, 3u8];
        let mapped_primitive = map_vector_primitive(primitive_vector);

        let vec1 = vector[1u8, 2u8];
        let vec2 = vector[3u8, 4u8];
        let vector_of_vectors = vector[vec1, vec2];
        let mapped_vec_of_vectors = map_vector_of_vectors(vector_of_vectors);

        (mapped_primitive, mapped_vec_of_vectors)
    }
}


//# run 0xCAFE::VectorMapTest::run_tests


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// dc640112dd36f0e7649f89c1f10d417a: Test that the Move function correctly performs addition and triggers an abort within an expression.
// 635fb0525118946a50130cecf3ee6bc4: Test that the std::vector::map function works correctly for both vectors of primitive types and vectors of vectors, including closure capturing and element mapping.
