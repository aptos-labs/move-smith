//# publish
module 0xCAFE::AdvancedTesting {
    use std::signer;

    // Specification for values, includes basic_properties spec
    spec module {
        include 0xCAFE::MyModule;
    }

    // Inline function accepting function parameter and using it
    public inline fun apply_and_sum(f: |u64,u64|u64, a: u64, b: u64): u64 {
        let res1 = f(a, b);
        let res2 = f(b, a);
        res1 + res2
    }

    // Function to test if-else variable assignment correctness
    public fun test_if_else_assignment(x: u8, cond: bool): u8 {
        let val: u8;
        if (cond) {
            val = x + 1;
        } else {
            val = x + 2;
        };
        val
    }

    // Runner function for apply_and_sum to be called without arguments
    public fun runner_apply_and_sum(): u64 {
        let lambda: |u64, u64| u64 has copy + drop = |a: u64, b: u64| { a * b };
        apply_and_sum(lambda, 3u64, 4u64)
    }

    // Runner function for test_if_else_assignment for both true and false cases
    public fun runner_if_else(): (u8, u8) {
        let res_true = test_if_else_assignment(10u8, true);
        let res_false = test_if_else_assignment(10u8, false);
        (res_true, res_false)
    }
}

//# run 0xCAFE::AdvancedTesting::runner_apply_and_sum

//# run 0xCAFE::AdvancedTesting::runner_if_else

// Featurres:
// aff962e217be66db8c4c44fb36053806: Include other expressions or specifications using 'include' in spec blocks
// b2e4d2efe99bb6aed3bfad8dd2c221b6: Test that inline functions accepting function parameters are correctly invoked and summed, verifying proper handling of function abstractions within module code.
// c33a429a40f19f299f04ce6f4fed9a08: Test that variables can be assigned within an if-else statement and retain the correct value after the conditional branch.
