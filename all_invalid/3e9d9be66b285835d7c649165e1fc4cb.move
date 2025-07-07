//# publish
module 0xDEAD::PatternMatchingTest {
    use std::vector;

    struct TestStruct has copy, drop {
        a: u8,
        b: bool,
    }

    public fun pattern_match_test(): () {
        // Initialize variables
        let x = 5u8;
        let y = true;
        let s = TestStruct { a: 10, b: false };

        // Pattern match with range list, destructure tuple
        let pair = (x, y);
        if (pair.0 >= 0 && pair.0 <= 10) {
            if (pair.1) {
                let _ = (pair.0, pair.1);
            } else {
                let _ = (pair.0, pair.1);
            }
        }

        // Pattern match with nested destructuring of structure with locations
        // Remove the '&' reference and directly match the value
        match s {
            TestStruct { a: a_val, b: b_val } => {
                // Use destructured variables
                let _ = a_val;
                let _ = b_val;
            }
        };

        // Pattern match with range list for number
        if (x >= 0 && x <= 10) {
            // do something
        } else {
            // do something else
        }
    }

    public fun run_all(): () {
        pattern_match_test()
    }
}
