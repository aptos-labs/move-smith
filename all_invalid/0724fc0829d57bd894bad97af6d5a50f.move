
//# publish
module 0xBADD::TestOperatorPrecedence {
    use std::assert;

    // Function with complex expression involving various operators
    public fun eval_exprs(): bool {
        let a = 2u8;
        let b = 3u8;
        let c = 1u8;
        // Operator precedence test: AND (&&) > OR (||), comparison (>), bitwise (&), arithmetic (+, *,)
        let result = ((a + b * c) > 10u8) || ((b & c) == 0u8) && false || (a == 2u8);
        // Expected: (2 + 3*1) = 5; 5 > 10? false; (b & c)=1&1=1; 1==0? false; a==2? true
        // Expression: false || false && false || true
        // Simplify: false || (false && false) || true => false || false || true => true
        result
    }

    // Function demonstrating the order of evaluation in complex nested expressions
    public fun complex_evaluation(): u8 {
        let x = 1u8;
        let y = 2u8;
        let z = 3u8;
        // Mix arithmetic, comparison, bitwise, logical operators
        let val = ((x + y) * z) as u8 + ((x | y) & z) as u8;
        val
    }

    // Function with multiple levels of precedence
    public fun precedence_test(): u8 {
        let a = 4u8;
        let b = 2u8;
        let c = 1u8;
        // expression: a + b * c - (a & b) | c
        // operators: * > + > - > |; & higher than + and -
        let result = a + b * c - (a & b) | c;
        // Calculation step-by-step:
        // b * c = 2 * 1 = 2
        // a + 2 = 4 + 2 = 6
        // a & b = 4 & 2 = 0
        // 6 - 0 = 6
        // 6 | c = 6 | 1 = 7
        result
    }

    // Function illustrating mixed comparison and bitwise operators
    public fun comparison_bitwise(): bool {
        let x = 0b1010u8; // 10
        let y = 0b1100u8; // 12
        // check if x < y AND if x | y == 0b1110 (14)
        let condition = (x < y) && ((x | y) == 0b1110u8);
        condition
    }

    // Function that combines logical, comparison, and bitwise operators in complex expression
    public fun combined_complex(): bool {
        let a = 5u8;
        let b = 10u8;
        let c = 3u8;
        // Expression: ((a << 1) > b) && ((b >> 1) + c) != 10 || (a & c) == 1
        let shifted_a = a << 1; // 10
        let condition1 = shifted_a > b; // 10 > 10? false
        let sum_b_c = (b >> 1) + c; // 5 + 3 = 8
        let condition2 = (sum_b_c != 10); // true
        let and_part = condition1 && condition2; // false && true = false
        let and_part2 = (a & c) == 1; // 5 & 3 = 1, 1==1? true
        // Final: false || true => true
        and_part || and_part2
    }

    // Function that uses return with a value
    public fun func_with_return(): u8 {
        let res = 42u8;
        return res;
    }

    // Function that uses return without a value
    public fun func_without_return(): u8 {
        // no explicit return, last expression
        100u8
    }

    // Function that calls other functions, returns their sum
    public fun combined_returns(): u8 {
        let val1 = func_with_return();
        let val2 = func_without_return();
        val1 + val2
    }

    // Inline non-private function calling another within same module to generate access warning
    public fun inline_call(): u8 {
        internal_helper()
    }

    fun internal_helper(): u8 {
        7u8
    }

    // Function calling other functions with mixed returns within an expression
    public fun mixed_call_in_expr(): u8 {
        let sum = func_with_return() + func_without_return();
        sum
    }
}

// Run expressions to validate complex evaluation and function returns



//# run 0xBADD::TestOperatorPrecedence::eval_exprs



//# run 0xBADD::TestOperatorPrecedence::complex_evaluation



//# run 0xBADD::TestOperatorPrecedence::precedence_test



//# run 0xBADD::TestOperatorPrecedence::comparison_bitwise



//# run 0xBADD::TestOperatorPrecedence::combined_complex



//# run 0xBADD::TestOperatorPrecedence::func_with_return



//# run 0xBADD::TestOperatorPrecedence::func_without_return



//# run 0xBADD::TestOperatorPrecedence::combined_returns



//# run 0xBADD::TestOperatorPrecedence::inline_call



//# run 0xBADD::TestOperatorPrecedence::mixed_call_in_expr


// Features:
// acf644e739cb4ed8a9e6290507388add: Verify that operator precedence rules are correctly implemented for logical, comparison, bitwise, and arithmetic operators in Move expressions.
// afb0a1624dc5f2c0b230db31bd6c92a1: Return values from functions using the 'return' keyword, optionally with an expression to return a value.
// 759d6a677489cb30b1d7f33b9438433d: Display access warnings when inline, non-private functions call functions within the same module, indicating potential access concerns.
