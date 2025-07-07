//# publish
module 0xCAFE::LambdaSpecTest {
    use std::vector;

    spec module {
        // Code-rich spec section with multiple invariants and temporal logic
        invariant {
            // A sample invariant ensuring some condition about a vector length
            forall i: u64 :: i < vector::length(vec) ==> vec[i] != 0;
        }

        spec update_vector_length {
            ensures vec_length == old(vec_length) + 1;
            let vec_length: u64 = vector::length(vec);
        }

        spec {
            // Nested spec block with conditions and assertions
            abort_if(vec_length > 100, 1);
        }
    }

    resource struct Counter {
        count: u64,
    }

    // A function with a lambda (anonymous function) expression
    public fun apply_lambda<F: copy + drop + store>(x: u64, f: F): u64
    where
        F: Fn(u64): u64,
    {
        f(x)
    }

    // A runner function which can be called without arguments
    public fun runner() {
        // Using lambda to add 10
        let add_ten = |a: u64| { a + 10 };
        let res = apply_lambda(5, add_ten);

        // Using lambda to multiply
        let mul_two = |a: u64| { a * 2 };
        let res2 = apply_lambda(res, mul_two);
    }
}

//# run 0xCAFE::LambdaSpecTest::runner

//# run 0xCAFE::LambdaSpecTest::apply_lambda --args 7u64 --signers 0xCAFE

// Featurres:
// 50be35204c12abb319efdf34d4e63b3d: Take advantage of multiple compiler optimization passes on Move source code and bytecode.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// ee5a0f621a575cb5ff249c843181b8ec: Create code-rich spec sections enclosed in '{' and '}' within a spec block.
