//# publish
module 0xCAFE::OperatorPrecedence {
    public fun test_logic_and_comparison(): bool {
        let a = true;
        let b = false;
        let c = true;

        // Operator precedence: '&&' higher than '||', '!' highest among logical operators
        let result = a || b && !c;
        // Evaluates as a || (b && (!c)) -> true || (false && false) -> true || false -> true
        result
    }

    public fun test_comparison_order(): bool {
        let x = 5u8;
        let y = 10u8;
        let z = 5u8;

        // '<' and '==' have same precedence but left to right evaluation
        // (x < y) == (z < y) -> (true) == (true) -> true
        let result = (x < y) == (z < y);
        result
    }

    public fun test_bitwise_precedence(): u8 {
        let a = 0b1010u8; // 10 decimal
        let b = 0b1100u8; // 12 decimal
        let c = 0b0011u8; // 3 decimal

        // '&' higher than '^', which is higher than '|'
        // Expression: a | b ^ c & a
        // Evaluates as a | (b ^ (c & a))
        // c & a = 0b0010 (2 decimal)
        // b ^ 2 = 0b1100 ^ 0b0010 = 0b1110 (14 decimal)
        // a | 14 = 0b1010 | 0b1110 = 0b1110 (14 decimal)
        let result = a | b ^ c & a;
        result
    }

    public fun test_mixed_operators(): bool {
        let a = true;
        let b = false;
        let x = 3u8;
        let y = 5u8;

        // Mixing logical and comparison operators
        // a && (x < y) || b && !(x == y)
        // Evaluates as (a && (x < y)) || (b && (!(x == y))) = (true && true) || (false && true)
        // -> true || false -> true
        let result = a && x < y || b && !(x == y);
        result
    }
}

//# run 0xCAFE::OperatorPrecedence::test_logic_and_comparison

//# run 0xCAFE::OperatorPrecedence::test_comparison_order

//# run 0xCAFE::OperatorPrecedence::test_bitwise_precedence

//# run 0xCAFE::OperatorPrecedence::test_mixed_operators

// Featurres:
// 22b6a875f14fef4e43a5a9ce161abbcc: Declare variables using valid Move identifiers
// 68ae2f5b9f9a5852aa1233765397d347: Define modules at the root of a package.
// fa13ae8844f6999f4ee0d23e96185bbd: Test that operator precedence for logical, comparison, and bitwise operators behaves according to standard rules in Move scripts.
