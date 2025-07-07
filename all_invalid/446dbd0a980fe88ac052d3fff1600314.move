
//# publish
module 0xBADD::PatternTest {
    use 0xDEAD::TestStructDestructuring;
    use std::vector;

    public fun complex_pattern_destructure(): u64 {
        let s = TestStructDestructuring::create_struct();
        // Destructuring a struct with pattern matching in assignment
        let TestStructDestructuring::ComplexStruct { a: a_val, b: b_val, c: c_vec } = s;

        // Using pattern in nested destructuring with inline-like evaluation
        let boolean_result: bool = {
            let local_vec = c_vec;
            let sum_b = b_val + 1;
            // creating a boolean based on vector size and sum
            *vector::borrow(&local_vec, 0) && (sum_b > 100)
        };

        // Final inline-like block with side effects and evaluation
        let side_effect_value: u64 = {
            let counter: u64 = 0;
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

        // Return the computed value
        side_effect_value
    }
}
