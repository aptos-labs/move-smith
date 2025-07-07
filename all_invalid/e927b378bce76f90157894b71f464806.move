
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

        // View initial state
        // View x, y, s.a, s.b (cannot print, but can assert or assign to variables)

        // Pattern match with range list, destructure tuple
        let pair = (x, y);
        if (pair.0 >= 0 && pair.0 <= 10) {
            if (pair.1) {
                let _ = (pair.0, pair.1);
            } else {
                let _ = (pair.0, pair.1);
            }
        };

        // View after pattern matching above

        // Pattern match with nested destructuring of structure with locations
        let struct_ref: &TestStruct = &s;
        match (struct_ref) {
            &TestStruct { a: a_val, b: b_val } => {
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
        };
    }

    public fun run_all(): () {
        pattern_match_test()
    }
}


//# run 0xDEAD::PatternMatchingTest::run_all


// Featurres:
// 6f9bd9a9a2cae557129d4bb569fe5333: Use byte string literals with the b" prefix.
// d4d86b2b4034f80cf9d967a21ee064f2: View the initialized state of variables before and after each instruction in a Move function.
// aab8db647c4ef1c04b48e80cb40955b7: Use pattern matching with location information for variable binding with range lists.
