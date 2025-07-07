
//# publish
module 0xCAFE::ControlFlowTest {
    use std::debug;

    /// Inline function to increment a u64 value by 1
    public inline fun inc(x: u64): u64 {
        x + 1
    }

    /// Function to test variables inside control flow: if, else, while, loop, block
    public fun test_control_flow(mut_x: u64): u64 {
        let x = mut_x;

        // if-else block with variable assignment and mutation
        if (x % 2 == 0) {
            let inner_var = x / 2;
            x = inner_var * 3;
        } else {
            let inner_var = x + 5;
            x = inner_var - 1;
        };

        // while loop that decrements x until less than 10, tracking x
        while (x > 10) {
            x = x - 1;
        };

        // loop with break after some condition, mutating x
        let count = 0;
        loop {
            if (count == 3) {
                break;
            };
            x = x + 2;
            count = count + 1;
        };

        // nested block scope with local variable shadowing and mutation
        {
            let x = x * 2;
            let _shadowed = x + 1; // local to this block
        };

        x
    }

    /// Function to test inline increment function and sum two increments plus initial value
    public fun test(): u64 {
        let base = 5u64;
        let first = inc(base);
        let second = inc(first);
        base + first + second
    }
}


//# run 0xCAFE::ControlFlowTest::test_control_flow --args 20u64


//# run 0xCAFE::ControlFlowTest::test


// Featurres:
// 80abe373b12be7aff51c4da15996be57: Track variables that are assigned or mutated inside control flow constructs such as blocks, conditions, and loops.
// 18a0a3ccca635e19e8dceadd6be8dd5c: Test that the inline function `inc` correctly increments a u64 value and that the `test` function accurately sums the initial value with two increments of that value.
// 375b016088e6d88efb893470d8dddbdb: Collect and handle diagnostics, including compilation errors, warnings, and comments, during the parsing process.
