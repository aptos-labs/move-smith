// Filename: ApplyTest.move

address 0x1 {
module ApplyTest {
    use std::signer;

    ////////////////////////
    // 1. Spec fun example //
    ////////////////////////

    // A simple spec function to add two u64 numbers.
    spec fun add_spec(a: u64, b: u64): u64 {
        a + b
    }

    // Spec function to check if a number is even.
    spec fun is_even_spec(x: u64): bool {
        x % 2 == 0
    }

    //////////////////////////////////////////
    // 2. Test `apply` function with lambdas //
    //////////////////////////////////////////

    /// This function takes a lambda `f` and two u64 arguments `x` and `y`.
    /// It applies the lambda to the arguments and returns the result.
    public fun apply(f: &mut (u64, u64) => u64, x: u64, y: u64): u64 {
        (*f)(x, y)
    }

    /// Nested apply: applies a lambda that calls apply again with a lambda that returns sum.
    /// Should return ((x + y) + (x + y)) = 2 * (x + y).
    public fun nested_apply(f: &mut (u64, u64) => u64, x: u64, y: u64): u64 {
        // inner lambda: sum of two numbers.
        let mut sum_lambda = |a: u64, b: u64| -> u64 { a + b };

        // apply f with x, y to get some value v
        let v = apply(f, x, y);

        // apply inner sum_lambda to v, v (doubling the result)
        apply(&mut sum_lambda, v, v)
    }

    ///////////////////////////////////////
    // 3. Bytecode generation for public functions
    ///////////////////////////////////////
    //
    // By default, functions that are public and not inline are compiled into bytecode.
    // Here, `apply` and `nested_apply` are public and non-inline, so bytecode will be generated
    // by the compiler.

    /////////////////////////////////////
    // TESTING TRANSACTION
    /////////////////////////////////////

    #[test_only]
    public fun test_apply_and_nested(): bool {
        let mut sum_lambda = |a: u64, b: u64| -> u64 { a + b };
        let res = apply(&mut sum_lambda, 3, 4);
        assert!(res == 7, 1);

        // Check with nested apply:
        let mut mul_lambda = |a: u64, b: u64| -> u64 { a * b };
        let nested_res = nested_apply(&mut sum_lambda, 2, 3);
        assert!(nested_res == 10, 2); // (2+3)*2=10

        // Check spec functions via spec assertions (no runtime cost)
        spec {
            let x = 5;
            let y = 7;
            let sum = add_spec(x, y);
            assert!(sum == 12, 3);
            assert!(is_even_spec(4), 4);
            assert!(!is_even_spec(5), 5);
        }

        true
    }
}
}

// Featurres:
// 0b6f2742d8864af5077463340b1d65fc: Define specification functions (spec fun) to encapsulate logic used in specifications and verification conditions.
// a2d395f7cc514b343f4569a28ad36e2a: Test that the `apply` function correctly executes a passed-in lambda function with provided arguments, and verify that nested `apply` calls produce the expected combined result.
// af34c34d028cde0ffe036333b37d9cfd: Generate bytecode for each non-inline function targeted for compilation.
