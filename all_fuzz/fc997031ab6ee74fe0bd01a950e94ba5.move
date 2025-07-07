
//# publish
module 0xCAFE::TestAddAndLambda {
    // This module tests addition of u8 values and uses lambdas and sequential statements with semicolon.

    public fun add_two_values(x: u8, y: u8): u8 {
        let sum = x + y;
        let _unused = 42;
        sum
    }

    public fun use_lambda_and_sequence(x: u8, y: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            let res = a + b;
            res
        };
        let res = lambda(x, y);
        let _dummy = 0u8;
        res
    }

    public fun sequence_statements(): u8 {
        let mut_x = 1u8;
        let mut_y = 2u8;
        let _ = mut_x;  // Using bindings to force parsing with semicolon
        let _ = mut_y;
        let z = mut_x + mut_y;
        let _ = 100u8;
        z
    }
}


//# run 0xCAFE::TestAddAndLambda::add_two_values --args 10u8 32u8


//# run 0xCAFE::TestAddAndLambda::use_lambda_and_sequence --args 7u8 8u8


//# run 0xCAFE::TestAddAndLambda::sequence_statements


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 48a6e5f69cc12e8cd8166426d661b232: Write sequences of statements in code blocks using the ';' separator
