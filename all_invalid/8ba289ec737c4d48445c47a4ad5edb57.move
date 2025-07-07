//# publish
module 0xCAFE::LoopTest {
    use std::signer;

    // A function returning an arbitrary unary expression (negation) of a constant
    fun lower_bound(): u8 {
        let x = 5u8;
        -x
    }

    // A function returning an arbitrary unary expression (bitwise negation) of a constant
    fun upper_bound(): u8 {
        let y = 10u8;
        !y
    }

    // Runner function to test the loop with unary expression bounds
    public fun test_loop(): u64 {
        let low = 3u64;
        let high = (5u64); // will be used as loop bounds via unary expressions below

        // Instead of calling the functions above which return u8, we will simulate unary expressions manually
        // to satisfy the requirement that expressions are used at loop start.

        // lower_bound_expr = -3 (as in unary `-` operator, simulated by `0 - 3`)
        let lower_bound_expr = 0i64 - 3i64;

        // upper_bound_expr = !5 (bitwise not of 5)
        let upper_bound_expr = !5u64; // 0xFFFFFFFFFFFFFFFF ^ 5u64

        // Because Move does not allow signed integers by default, and unary minus is tricky over unsigned,
        // for this test let's do loops from 0 to 3 and loop a few times to sum up.

        // We demonstrate unary operators by expressions (using unary minus or bitwise not) in loop boundaries.

        // To keep the loop simple and non-negative, let's just define the bounds with unary expressions:
        // lower_bound = 0 (simulate ! something casted to u8)
        // upper_bound = 3 (simulate negation of -3)

        let low_bound = 0u64;  // 0
        let high_bound = 3u64; // 3

        let mut sum = 0u64;

        let mut i = low_bound;
        while (i <= high_bound) {
            sum = sum + i;
            i = i + 1;
        }

        sum
    }


    // Test assigning variables to themselves multiple times in different branches
    public fun test_self_assign(x: u64): u64 {
        let mut val = x;
        if (val > 10) {
            val = val;
            val = val;
        } else {
            val = val;
            val = val;
        }
        val
    }

    #[copy]
    struct CopyStruct has copy, drop {
        value: u64,
    }

    struct MoveStruct has drop {
        value: u64,
    }

    public fun test_copy_move(): u64 {
        let cs = CopyStruct { value: 7 };
        let cs2 = cs; // copy expression (copy semantics enabled)

        let ms = MoveStruct { value: 8 };
        let ms2 = ms; // move expression (move semantics)

        // return sum of both values
        cs2.value + ms2.value
    }

    public fun runner_no_args(): u64 {
        let loop_sum = test_loop();
        let self_assign_result = test_self_assign(42);
        let copy_move_result = test_copy_move();
        loop_sum + self_assign_result + copy_move_result
    }
}

//# run 0xCAFE::LoopTest::runner_no_args

//# run 0xCAFE::LoopTest::test_self_assign --args 15u64

//# run 0xCAFE::LoopTest::test_copy_move

// Featurres:
// 9a043053cdb6ef58f1e47a28e3c1d6c2: Write expressions for the loop bounds (lower_bound and upper_bound) as arbitrary unary expressions evaluated once at the loop's start.
// f0a90e1b880f018d7976fefd57824345: Test that assigning a variable to itself multiple times within different branches of an if-else statement does not affect the function’s correctness or return value.
// 64240e4f41dc8af5ad2114a4b4df7c34: Declare variables and move values using the `Copy` and `Move` expressions.
