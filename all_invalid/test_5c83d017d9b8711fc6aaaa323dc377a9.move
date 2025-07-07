//# publish
module 0xABCDEF::test_module {
    use std::vector;

    /// Function that increments a counter until it reaches 10, then breaks.
    public fun increment_until_ten(): u64 {
        let mut counter = 0;
        loop {
            if (counter >= 10) break;
            counter = counter + 1;
            continue;
        };
        // Final check for correct value
        move(counter)
    }

    /// Function that applies complex logical and arithmetic expressions to verify operator precedence.
    public fun verify_precedence(): bool {
        // Using assertions internally for testing logic operator precedence.
        // These will be tested via assert! in script.
        assert!(true || false && false, 200); // '&&' has precedence over '||'
        assert!((1 + 2 * 3) == 7, 201); // '*' over '+'
        assert!((1 | 2 ^ 3) == 0, 202); // '|' and '^', bitwise operators
        assert!((true && false || true) == true, 203); // '&&' over '||'
        assert!(((5 - 3) * 4) == 8, 204);
        move(true)
    }

    /// Runner function to execute verification.
    public fun run_verify_precedence(): bool {
        verify_precedence()
    }
}

//# run 0xABCDEF::test_module::increment_until_ten
//# run 0xABCDEF::test_module::run_verify_precedence --signers 0x1 --args