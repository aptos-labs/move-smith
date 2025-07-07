
//# publish
module 0xCAFE::OverflowAndLoopTest {
    use std::signer;

    const MAX_U8: u8 = 255u8;

    struct Counter has store {
        value: u8,
    }

    public fun run_loop_with_break(): u8 {
        let counter = 0u8;
        let result = 0u8;
        loop {
            counter = counter + 1;
            if (counter == 5) {
                result = counter;
                break;
            };
        };
        // Result should be 5 here if loop and break works correctly
        result
    }

    public fun attempt_overflow(): u8 {
        // This expression overflows u8: 255u8 + 1u8
        let x = MAX_U8 + 1u8;
        x
    }

    public fun division_by_zero(): u8 {
        let x = 10u8 / 0u8;
        x
    }

    public fun modulo_by_zero(): u8 {
        let x = 10u8 % 0u8;
        x
    }

    public fun invalid_type_cast(): u8 {
        // Cast larger than u8 max: 256u16 to u8, which should abort
        let x = 256u16 as u8;
        x
    }

    public fun runner() {
        let _ = run_loop_with_break();
    }
}


//# run 0xCAFE::OverflowAndLoopTest::run_loop_with_break


//# run 0xCAFE::OverflowAndLoopTest::runner


//# run 0xCAFE::OverflowAndLoopTest::attempt_overflow


//# run 0xCAFE::OverflowAndLoopTest::division_by_zero


//# run 0xCAFE::OverflowAndLoopTest::modulo_by_zero


//# run 0xCAFE::OverflowAndLoopTest::invalid_type_cast


// Featurres:
// f3fe8548f5064f4cacde58056ce40e0c: Test that variables updated inside a loop are correctly assigned when a break statement is used.
// 3791ac15e9d738e5bd320f39ae9a7a6b: Test that constant expressions which would cause overflows, division/modulo by zero, or out-of-range type casts are not silently simplified away and correctly abort at runtime.
// ef8758a86bf601a8d562b28d5806c116: Define struct types within a module.
