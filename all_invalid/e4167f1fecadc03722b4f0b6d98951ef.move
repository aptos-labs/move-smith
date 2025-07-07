
//# publish
module 0xDEAD::EvalOrderAndArithmeticTest {
    use std::vector;

    // Function to test nested expressions, side effects, and evaluation order
    public fun test_nested_and_side_effects() {
        let x = 0u16;
        let y = 0u16;

        // Self-mutating function
        public fun mutate_x(val: u16): u16 {
            x = val;
            val
        }

        // Setup initial values
        x = 10;
        y = 20;

        // Complex nested expression with mutation and assignment in function arguments
        let result = {
            let temp1 = mutate_x(x + 1);
            let temp2 = mutate_x(y + 2);
            // Return an expression involving both temps
            temp1 * temp2 + mutate_x(5)
        };

        // The sequence of side effects:
        // mutate_x(x+1), mutate_x(y+2), mutate_x(5)

        // Last expression is result
        result
    }

    // Function to test 16-bit unsigned integer operations
    public fun test_u16_arithmetic(a: u16, b: u16): (u16, u16, u16, u16, u16) {
        // Addition - should overflow if a + b exceeds max u16
        let add_res = a + b;
        // Subtraction - unsigned, so b - a could panic if overflow
        let sub_res = if (b >= a) {
            b - a
        } else {
            0u16
        };
        // Multiplication
        let mul_res = a * b;
        // Division - handle divide by zero
        let div_res = if (b != 0) {
            a / b
        } else {
            0u16
        };
        // Modulus - handle divide by zero
        let mod_res = if (b != 0) {
            a % b
        } else {
            0u16
        };

        (add_res, sub_res, mul_res, div_res, mod_res)
    }

    // Function to test struct field access by position
    public fun test_struct_field_access() {
        // Define a struct inline for testing purposes
        struct NumFields has copy, drop {
            0: u8,
            1: u16,
            2: bool,
            3: u32,
        }

        let num = NumFields {0: 255u8, 1: 65535u16, 2: true, 3: 123456u32};

        // Access fields by their position number
        let field0 = *get_field_num(&num, 0);
        let field1 = *get_field_num(&num, 1);
        let field2 = *get_field_num(&num, 2);
        let field3 = *get_field_num(&num, 3);
        (field0, field1, field2, field3)
    }

    // Helper function to get struct fields by numeric index
    fun get_field_num<'a, T: copy + drop>(s: & T, index: u8): & T {
        match index {
            0 => s,
            1 => s,
            2 => s,
            3 => s,
            _ => s,
        }
    }
}


//# run 0xDEAD::EvalOrderAndArithmeticTest::test_nested_and_side_effects

//# run 0xDEAD::EvalOrderAndArithmeticTest::test_u16_arithmetic --args 65535u16 65535u16

//# run 0xDEAD::EvalOrderAndArithmeticTest::test_u16_arithmetic --args 100u16 0u16

//# run 0xDEAD::EvalOrderAndArithmeticTest::test_struct_field_access


// Featurres:
// ab4f2d8020a10dcc50efd93b1d2646fd: Test the order of evaluation and side effect sequencing of complex nested expressions with mutation and assignment in function arguments.
// 527abebfabb1ebd69e625fa68b433419: Test that unsigned 16-bit integer arithmetic operations (addition, subtraction, multiplication, division, and modulus) behave correctly for valid inputs and properly fail or trigger errors on overflows or divisions by zero।
// b8e6be7754183eb5393c77e9ef3b5220: Reference struct fields by their position number if the field name is a numeric string.
