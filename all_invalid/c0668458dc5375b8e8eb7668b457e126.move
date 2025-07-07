
//# publish
module 0xCAFE::FeatureTest {
    use std::vector;

    // Function to test match with variable bindings
    public fun match_with_binding(value: u8): u8 {
        let result = match (value) {
            0 => {
                let x = 42;
                x
            },
            1 => {
                let y = 7;
                y
            },
            _ => {
                let z = 99;
                z
            }
        };
        result
    }

    // Function to test u128 arithmetic operations
    public fun u128_arith_ops() {
        let a: u128 = 100;
        let b: u128 = 25;

        // Addition test
        let sum = a + b;

        // Subtraction test
        let diff = a - b;

        // Multiplication test
        let prod = a * b;

        // Division test
        let quotient = a / b;

        // Modulo test
        let rem = a % b;

        // Try overflow addition (should abort)
        // The following line is commented out because it causes panic during test
        // let _overflow_add = (u128::MAX) + 1;

        // Attempt division by zero (should abort)
        // let _div_by_zero = a / 0;

        // Attempt modulo by zero (should abort)
        // let _mod_by_zero = a % 0;

        // return sum for verification
        sum
    }

    // Function to test subtraction resulting in negative (which should abort)
    public fun subtraction_negative() {
        let x: u128 = 10;
        let y: u128 = 20;
        // This subtraction should abort
        let _res = x - y;
        // Should not reach here
        0
    }

    // Functions to test complex nested shadowing with destructuring
    public fun shadowing_test() {
        let x = 5;

        let result = {
            let x = 10; // shadow outer x
            {
                let x = 15; // shadow inner x
                // Inside inner block, x should be 15
                x
            } + x // outer x (5) + inner x (15)
        };

        // The value of result should be 20
        result
    }

    // Function to test multiple variable shadowing with pattern destructuring
    public fun destructure_and_shadow() {
        let tuple = (1u8, 2u8);
        let (a, b) = tuple; // shadow a, b

        {
            let (a, b) = (3u8, 4u8); // shadow again within block
            // Inside this block a=3, b=4
            let sum_inner = a + b;
            // sum_inner = 7
            sum_inner
        } + a + b // outer a = 1, outer b=2, sum inner=7
    }
}



//# run 0xCAFE::FeatureTest::match_with_binding --args 0u8


//# run 0xCAFE::FeatureTest::match_with_binding --args 1u8


//# run 0xCAFE::FeatureTest::match_with_binding --args 5u8



//# run 0xCAFE::FeatureTest::u128_arith_ops



//# run 0xCAFE::FeatureTest::subtraction_negative



//# run 0xCAFE::FeatureTest::shadowing_test



//# run 0xCAFE::FeatureTest::destructure_and_shadow