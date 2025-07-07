
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

        // 'while' loop within expression
        let count = 0;
        let result = while (count < 3, {
            acc = acc + (count as u64);
            count = count + 1;
        }) {
            count
        };

        // 'loop' with break condition
        let i = 0;
        let total: u64 = 0;
        loop {
            if (i >= 5) {
                break;
            }
            total = total + 1;
            i = i + 1;
        };

        // Lambda (anonymous function) with captured variables
        let add_lambda = |a: u8, b: u8| { a + b };
        let sum = add_lambda(5, 10);

        cond && (result == 2) && (total == 5) && (sum == 15)
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

// Featurres:
// 7553b3396efb5ff4938a88b0a953cbe8: Test all comparison operators (==, !=, <, >, <=, >=) for all unsigned integer types (u8, u16, u32, u64, u128, u256) to ensure they behave correctly for equal, lesser, and greater values.
// a853f5fb5a697c8d86582f6705936d1f: Write control flow expressions such as 'if', 'while', and 'loop' statements within expressions.
// c0c8a4b2360d571e1626e0a75d202223: Define anonymous functions (lambdas) with the `lambda` expression, including parameter bind lists, the body expression, capture kind, and optional specification.
