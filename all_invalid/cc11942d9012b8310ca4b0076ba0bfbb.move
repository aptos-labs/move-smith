
//# publish
module 0xCAFE::ComparisonOperators {
    public fun compare_u8(val1: u8, val2: u8): (bool, bool, bool, bool, bool, bool) {
        (
            val1 == val2,
            val1 != val2,
            val1 < val2,
            val1 > val2,
            val1 <= val2,
            val1 >= val2
        )
    }

    public fun compare_u16(val1: u16, val2: u16): (bool, bool, bool, bool, bool, bool) {
        (
            val1 == val2,
            val1 != val2,
            val1 < val2,
            val1 > val2,
            val1 <= val2,
            val1 >= val2
        )
    }

    public fun compare_u32(val1: u32, val2: u32): (bool, bool, bool, bool, bool, bool) {
        (
            val1 == val2,
            val1 != val2,
            val1 < val2,
            val1 > val2,
            val1 <= val2,
            val1 >= val2
        )
    }

    public fun compare_u64(val1: u64, val2: u64): (bool, bool, bool, bool, bool, bool) {
        (
            val1 == val2,
            val1 != val2,
            val1 < val2,
            val1 > val2,
            val1 <= val2,
            val1 >= val2
        )
    }

    public fun compare_u128(val1: u128, val2: u128): (bool, bool, bool, bool, bool, bool) {
        (
            val1 == val2,
            val1 != val2,
            val1 < val2,
            val1 > val2,
            val1 <= val2,
            val1 >= val2
        )
    }

    public fun compare_u256(val1: u256, val2: u256): (bool, bool, bool, bool, bool, bool) {
        (
            val1 == val2,
            val1 != val2,
            val1 < val2,
            val1 > val2,
            val1 <= val2,
            val1 >= val2
        )
    }

    public fun control_flow_test(): bool {
        let acc: u64 = 0;
        // Using 'if' in a value expression
        let cond = if (acc == 0) {
            acc = 10;
            true
        } else {
            false
        };

        // 'while' loop within expression: move the 'while' outside of assignment
        let count = 0;
        let result;
        while (count < 3) {
            // loop body
            acc = acc + (count as u64);
            count = count + 1;
        }
        result = count;

        // 'loop' with break condition
        let i = 0;
        let total: u64 = 0;
        let j = i; // variable for the loop index
        // Use 'loop' construct properly
        let loop_counter = 0;
        loop {
            if (loop_counter >= 5) {
                break;
            }
            total = total + 1;
            // simulate i++ by using a loop counter
            // Because Move does not support incrementing variables in the same way as other languages,
            // but to match the semantics, we can just break after 5 iterations
            // so using loop_counter to count
            // increase loop_counter
            // But since in Move, variables are linear and immutable, we implement via a recursive function or similar
            // but to simplify, just use a recursive function or a while loop outside.
            // For the sake of this test, we can just mimic break condition.
            break;
        };

        // Lambda (anonymous function) with captured variables
        let add_lambda = |a: u8, b: u8| { a + b };
        let sum = add_lambda(5, 10);

        cond && (result == 3) && (total == 5) && (sum == 15)
    }

    public fun test_lambda(): u8 {
        // Define a lambda with two parameters
        let lambda_func = |x: u8, y: u8| { x * y };
        // Call the lambda
        lambda_func(3, 4)
    }
}



//# run 0xCAFE::ComparisonOperators::compare_u8 --args 5u8 5u8


//# run 0xCAFE::ComparisonOperators::compare_u16 --args 10u16 20u16


//# run 0xCAFE::ComparisonOperators::compare_u32 --args 100u32 100u32


//# run 0xCAFE::ComparisonOperators::compare_u64 --args 300u64 200u64


//# run 0xCAFE::ComparisonOperators::compare_u128 --args 1000u128 999u128


//# run 0xCAFE::ComparisonOperators::compare_u256 --args 123456789u256 123456789u256



//# run 0xCAFE::ComparisonOperators::compare_u8 --args 10u8 20u8


//# run 0xCAFE::ComparisonOperators::compare_u16 --args 30u16 15u16


//# run 0xCAFE::ComparisonOperators::compare_u32 --args 50u32 25u32


//# run 0xCAFE::ComparisonOperators::compare_u64 --args 400u64 500u64


//# run 0xCAFE::ComparisonOperators::compare_u128 --args 0u128 1u128


//# run 0xCAFE::ComparisonOperators::compare_u256 --args 999999999u256 888888888u256



//# run 0xCAFE::ComparisonOperators::test_lambda --signers 0xCAFE