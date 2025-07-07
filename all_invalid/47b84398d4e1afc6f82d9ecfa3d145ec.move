//# publish
module 0xCAFE::BlockExpressions {
    struct S has copy, drop, store {
        x: u64,
        y: u64,
    }

    public fun test_block_expression(): u64 {
        let mut a = 1;
        let b = {
            a = a + 1;
            let c = a * 2;
            c + {
                a = a + 2;
                a
            }
        };
        // After the block, a should be 4, b should reflect nested mutations
        a + b // returns 4 + (2 * 2 + 4) = 4 + (4 + 4) = 12
    }

    public fun runner_block(): u64 {
        test_block_expression()
    }
}

//# run 0xCAFE::BlockExpressions::runner_block

//# publish
module 0xCAFE::LoopContinue {
    public fun runner_loop(): u64 {
        let mut x = 0;
        let mut y = 0;

        loop {
            x = x + 1;
            if (x % 2 == 0) {
                continue;
            };
            y = y + x;
            if (x == 10) {
                break;
            };
        };
        // Sum of odd numbers from 1 to 9 = 25
        y
    }
}

//# run 0xCAFE::LoopContinue::runner_loop

//# publish
module 0xCAFE::PatternUnpack {
    struct Point has copy, drop, store {
        x: u64,
        y: u64,
        z: u64,
    }

    public fun runner_unpack(): u64 {
        let p = Point { x: 5, y: 10, z: 15 };
        // Positional unpack with ignoring the last field using ..
        let Point { x, y, .. } = p;
        x + y // should be 15
    }
}

//# run 0xCAFE::PatternUnpack::runner_unpack


//# run
script {
    // Just an empty script to ensure script compilation and VM execution
    // No args needed
}

// Featurres:
// 044221690c4f2b9fba1caf69665ef8af: Test that block expressions can be used as values and reflect variable mutations within nested scopes in Move.
// ab90f7da459bbdcaecb88cf63392fe44: Test that a loop correctly skips even increments of x using continue and terminates when x reaches 10, verifying accumulated value y equals 25.
// 99e0c7dc69100368ea067e3fb522be33: Perform positional unpacking of struct or variant patterns with support for a single `..` to ignore remaining fields.
