
//# publish
module 0xDEAD::FirstClassCallTest {
    use std::vector;

    // A module to test feature 1: Call expressions as first-class values
    struct Callable has copy, drop, store {
        f: vector<u8>,
    }

    public fun new_callable(f: vector<u8>): Callable {
        Callable { f }
    }

    public fun call_with_args(callable: &Callable, arg1: u8, arg2: u8): u8 {
        // Simulate calling the stored function (represented here as a vector of bytes)
        // Map the call: for testing, sum the arguments mod 256
        (arg1 + arg2) % 256
    }

    // A nested lambda function used as a value
    public fun use_lambda(x: u8): u8 {
        let lambda: |u8| -> u8 = |a: u8| {
            a + 10
        };
        lambda(x)
    }

    // Feature 2: Remove tail jump instructions
    // We create a sequence with tail jumps that should be optimized away
    public fun tail_jump_sequence(): u64 {
        let x: u64 = 0;
        // emulate sequence leading to tail jump optimization
        let x1 = {
            let y = 1;
            y
        }; // no tail jump here, just sequence
        let x2 = {
            let y = 2;
            y
        }; // similar
        // merge results
        x1 + x2
    }

    // Feature 3: Lift lambda functions into higher scopes with optional inline functions
    public fun outer_scope(x: u8): u8 {
        // inline lambda
        let lambda_inline: |u8| -> u8 = |a: u8| {
            a + x
        };

        // As a nested named lambda
        let nested_lambda: |u8| -> u8 = |a: u8| {
            lambda_inline(a) * 2
        }; 

        nested_lambda(3)
    }

    // Runner to execute all test features
    public fun run_tests(): (u8, u8, u64, u8) {
        let call = new_callable(vector[b"test_f"]);
        let result1 = call_with_args(&call, 5u8, 10u8);
        let result2 = use_lambda(7u8);
        let result3 = tail_jump_sequence();
        let result4 = outer_scope(5u8);
        (result1, result2, result3, result4)
    }
}


//# run 0xDEAD::FirstClassCallTest::run_tests


// Featurres:
// e0cc0eb5a0e248d117c73b8ec2f355c6: Call expressions as first-class values, passing argument lists dynamically.
// 83a43ca15238e965f28c38cb19bc6a33: Remove tail jump instructions from code sequences
// b96aa00a04c014ffafa027357a5737bb: Lift lambda functions into higher scopes with optional inline function inclusion.
