//# publish
module 0xCAFE::LoopAndOperators {
    use std::signer;
    use std::vector;
    use std::option;

    // This struct just exists to test storing something if needed
    struct Dummy has copy, drop, store, key {
        value: u64,
    }

    public fun runner(): bool {
        // 1. Test a for loop iterating from 0 to 10 inclusive: sum i over 0..=10
        let sum: u64 = 0;
        let start: u64 = 0;
        let end: u64 = 10;
        // Move does not allow 'mut' keyword and 'for' variable can't be declared before the loop

        let mut sum = sum;
        for i in 0..=10 {
            sum = sum + i;
        };

        // sum of 0..=10 = 55u64

        // 2. Function body with sequence of statements and expressions:
        let val1: u8 = 5;
        let mut val1 = val1;
        val1 = val1 + 1;       // val1 = 6
        val1 = val1 * 2;       // val1 = 12
        val1 = val1 - 4;       // val1 = 8

        // 3. Binary operators: Let's test lots of operators with variables:
        let a: u8 = 12;
        let b: u8 = 5;

        // arithmetic operators +, -, *, /, %
        let add = a + b;         // 17
        let sub = a - b;         // 7
        let mul = a * b;         // 60
        let div = a / b;         // 2
        let rem = a % b;         // 2

        // comparison operators: ==, !=, <, <=, >, >=
        let eq = (a == b);       // false
        let neq = (a != b);      // true
        let lt = (a < b);        // false
        let lte = (a <= b);      // false
        let gt = (a > b);        // true
        let gte = (a >= b);      // true

        // logical operators: &&, ||
        let logical_and = (eq && neq);  // false && true = false
        let logical_or = (neq || eq);   // true || false = true

        // Bitwise operators: |, &, ^, <<, >>
        let bit_or = a | b;       // 12 | 5 = 13 (0b1100|0b0101=0b1101=13)
        let bit_and = a & b;      // 12 & 5 = 4  (0b1100&0b0101=0b0100=4)
        let bit_xor = a ^ b;      // 12 ^ 5 = 9  (0b1100^0b0101=0b1001=9)

        // shifts:
        let shift_left = a << 1;  // 12 << 1 = 24
        let shift_right = a >> 2; // 12 >> 2 = 3

        // range operators: '..' and '..='
        // '..' is half-open range: 0..5 (0,1,2,3,4)
        // '..=' closed range: 0..=5 (0..5)
        let sum_half_open: u64 = 0;
        let mut sum_half_open = sum_half_open;
        for i in 0..5 {
            sum_half_open = sum_half_open + i;
        };

        // sum 0..5 = 10 (0+1+2+3+4)

        let sum_closed: u64 = 0;
        let mut sum_closed = sum_closed;
        for i in 0..=5 {
            sum_closed = sum_closed + i;
        };

        // sum 0..=5 = 15 (0+1+2+3+4+5)

        // Since '=>=', '<==>', etc are not valid operators in Move, we show that these do not compile by comments:
        //
        // let x = a =>= b;  // invalid - no such operator
        // let y = a <==> b; // invalid - no such operator
        //
        // (They are omitted because these are syntactically invalid and will cause compile errors)

        // We return true if all conditions that are valid here logically expected are met.

        // Validate sums:
        let sums_correct = sum == 55 && sum_half_open == 10 && sum_closed == 15;
        // Validate arithmetic operators correctness:
        let arith_correct = add == 17 && sub == 7 && mul == 60 && div == 2 && rem == 2;
        // Validate comparison operators correctness:
        let comp_correct = eq == false && neq == true && lt == false && lte == false && gt == true && gte == true;
        // Validate logical operators correctness:
        let logical_correct = logical_and == false && logical_or == true;
        // Validate bitwise operators correctness:
        let bitwise_correct = bit_or == 13 && bit_and == 4 && bit_xor == 9 && shift_left == 24 && shift_right == 3;

        sums_correct && arith_correct && comp_correct && logical_correct && bitwise_correct
    }
}
//# run 0xCAFE::LoopAndOperators::runner

//# run
script {
    use 0xCAFE::LoopAndOperators;

    fun main() {
        let success = LoopAndOperators::runner();
        // no assertion needed per instructions
    }
}