
//# publish
module 0xCAFE::OverflowAndLoopTest {
    use std::option;
    use std::u8;

    const MAX_U8: u8 = 255u8;

    struct Counter has store {
        value: u8,
    }

    public fun run_loop_with_break(): u8 {
        let counter = 0u8;
        let result = 0u8;
        loop {
            let counter = counter + 1;
            if (counter == 5) {
                let result = counter;
                break;
            };
        };
        // Result should be 5 here if loop and break works correctly
        result
    }

    public fun attempt_overflow(): u8 {
        // To avoid compile-time overflow, do checked addition at runtime
        let x = u8::checked_add(MAX_U8, 1u8);
        // If overflow occurs, abort with code 1
        assert!(option::is_some(&x), 1);
        option::borrow(&x)
    }

    public fun division_by_zero(): u8 {
        let divisor = 0u8;
        // Prevent immediate divide by zero panic in the VM, abort with code 2
        assert!(divisor != 0, 2);
        10u8 / divisor
    }

    public fun modulo_by_zero(): u8 {
        let divisor = 0u8;
        // Prevent modulo by zero panic in the VM, abort with code 3
        assert!(divisor != 0, 3);
        10u8 % divisor
    }

    public fun invalid_type_cast(): u8 {
        let value = 256u16;
        // Check if value fits in u8 before casting, abort with code 4 if not
        assert!(value <= 255u16, 4);
        let x = value as u8;
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
