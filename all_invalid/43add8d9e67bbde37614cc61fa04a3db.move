//# publish
module 0xCAFE::ComplexExpressionsAndLoops {
    use std::debug;

    public fun inc_and_return_x(mut_x: u8): u8 {
        // Non-trivial sequence expression with side effect: increment then return old value
        let res = (mut_x, mut_x + 1).0;
        res
    }

    public fun test_seq_expr_binary_ops(): u8 {
        // a non-trivial sequence expression on the left of +
        let lhs = { 
            let mut x = 1u8;
            x = x + 1;
            x
        };
        // a non-trivial sequence expression on the right of *
        let rhs = {
            let mut y = 2u8;
            y = y + 2;
            y
        };
        // correct usage of parentheses for sequencing and also binary ops
        let val = (lhs + 1) * (rhs - 1);
        val
    }

    public fun infinite_loop_break_example(): u8 {
        let mut counter = 0u8;
        loop {
            counter = counter + 1;
            if (counter == 5) {
                break;
            };
        };
        counter
    }

    public fun loop_with_if_return(): u8 {
        let mut x = 0u8;
        loop {
            x = x + 1;
            if (x == 3) {
                // early return from loop and function
                return x;
            };
        };
        // unreachable but needed for syntax
        0
    }
}

//# run 0xCAFE::ComplexExpressionsAndLoops::test_seq_expr_binary_ops

//# run 0xCAFE::ComplexExpressionsAndLoops::infinite_loop_break_example

//# run 0xCAFE::ComplexExpressionsAndLoops::loop_with_if_return

// Featurres:
// 9999b96aafc20d2893411f661fd93de2: Include non-trivial sequence expressions (with side effects) as operands in binary operations, but be aware that it is not allowed under some language versions.
// dbb07a73ec828fd112d3a2a96fa37a81: Use 'loop' constructs to create infinite or indefinite loops.
// 0152aafeff6b98a8df2dd0b869900afd: Test that the `loop return` statement correctly exits a script even when used inside an `if` block.
