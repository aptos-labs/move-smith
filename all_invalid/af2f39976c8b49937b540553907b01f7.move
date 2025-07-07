
//# publish
module 0xDEAD::TestStructDestructuring {
    use std::vector;

    struct ComplexStruct has store, key {
        a: u8,
        b: u16,
        c: vector<bool>,
    }

    public fun create_struct(): ComplexStruct {
        let v = vector::empty<bool>();
        vector::push_back(&mut v, true);
        vector::push_back(&mut v, false);
        let s = ComplexStruct {
            a: 1,
            b: 65535,
            c: v,
        };
        s
    }
}


//# run 0xDEAD::TestStructDestructuring::create_struct


//# publish
module 0xBADD::PatternTest {
    use 0xDEAD::TestStructDestructuring;
    use std::vector;

    public fun complex_pattern_destructure() {
        let s = TestStructDestructuring::create_struct();
        // Destructuring a struct with pattern matching in assignment
        let TestStructDestructuring::ComplexStruct { a: a_val, b: b_val, c: c_vec } = s;

        // Using pattern in nested destructuring with inline-like evaluation
        let boolean_result = {
            let local_vec = c_vec;
            let sum_b = b_val + 1;
            // creating a boolean based on vector size and sum
            *vector::borrow(&local_vec, 0) && (sum_b > 100)
        };

        // Final inline-like block with side effects and evaluation
        let side_effect_value = {
            let counter = 0u8;
            if (a_val == 1) {
                counter = counter + 1;
            } else {
                counter = counter + 2;
            };
            // produce a value based on pattern matching
            if (boolean_result) {
                counter + 10
            } else {
                counter + 20
            }
        };

        // Use the computed value in an operation
        let result = side_effect_value;
        result
    }
}


//# run 0xBADD::PatternTest::complex_pattern_destructure


// Featurres:
// aa7ff054634cd6f0f8454357e5a1f2f2: Use patterns to destructure complex data structures on the left-hand side of an assignment.
// 9b6096659f32566b68b5dfcb8fef2c71: Test that the Move language correctly evaluates multiple inline-like code blocks with side effects in an expression and returns the expected final value.
// 1b8090c716e7400a1b3e5125a5644828: Automatically add dependency edges from modules outside the `vector` dependency closure to the `vector` module if it exists.
