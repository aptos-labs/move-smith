
//# publish
module 0xDEAD::EvalOrderAndArithmeticTest {
    use std::vector;

    // Function to test nested expressions, side effects, and evaluation order
    public fun test_nested_and_side_effects() {
        let x = 0u16;
        let y = 0u16;

        // Self-mutating function
        fun mutate_x(val: u16): u16 {
            // Mutate the variable x
            // Note: move semantics require 'mut' variables; assign directly
            // But variables in Move are immutable by default; to mutate, declare as 'mut'
            // We need 'mut' declared outside the function if we want to mutate them
            // Alternatively, to simulate side effects, we can perform mutations through references
            // But Move doesn't support variable mutation via references easily
            // So, better to declare 'x' as a mutable variable outside and mutate directly

            // Since Move functions are pure unless they accept references and mutate,
            // for simplicity, we should mutate outside and pass the new value to the function if needed.
            // But in the context of a test, to simulate mutation, we can just do the operations directly.

            // As Move does not support mutable local variables inside functions without 'mut' declaration,
            // we should declare 'x' as mutable outside and do the mutation there.

            // Therefore, refactor approach: define 'mutate_x' as a helper that takes &mut variable

            // But the initial code attempts to assign to 'x' inside function, which is invalid in Move.
            // Instead, we will simulate side effects by passing the variable and returning a new value.
            // So, rewrite 'mutate_x' as a pure function that returns the mutated value.

            val
        }

        // Setup initial values
        // To mutate 'x' and 'y', declare them as mutable, and mutate outside
        let x_val = 10u16;
        let y_val = 20u16;

        // Define local mutate functions that mutate the variables
        // Since Move functions cannot mutate captured variables directly, do the mutation inline
        let result = {
            // simulate mutate_x(x + 1)
            x_val = x_val + 1;
            let temp1 = x_val;

            // simulate mutate_x(y + 2)
            y_val = y_val + 2;
            let temp2 = y_val;

            // perform mutation for 'mutate_x(5)'
            x_val = 5;
            let temp3 = x_val;

            // Compute expression
            temp1 * temp2 + temp3
        };

        // Return result
        result
    }

    // Function to test 16-bit unsigned integer operations
    public fun test_u16_arithmetic(a: u16, b: u16): (u16, u16, u16, u16, u16) {
        // Addition - should overflow if a + b exceeds max u16
        let add_res = a + b;
        // Subtraction - unsigned, so b - a could panic if underflow
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
        let field0 = get_field_num(&num, 0);
        let field1 = get_field_num(&num, 1);
        let field2 = get_field_num(&num, 2);
        let field3 = get_field_num(&num, 3);
        (field0, field1, field2, field3)
    }

    // Helper function to get struct fields by numeric index
    fun get_field_num<'a>(s: &NumFields, index: u8): 
        ('a, u8) // Changed to return the actual value with correct type
    {
        match index {
            0 => (*s).0,
            1 => (*s).1,
            2 => (*s).2 as u8, // Simplify: cast bool to u8
            3 => (*s).3 as u8, // Truncate u32 to u8 for illustration
            _ => 0u8,
        }
    }
}



//# run 0xDEAD::EvalOrderAndArithmeticTest::test_nested_and_side_effects


//# run 0xDEAD::EvalOrderAndArithmeticTest::test_u16_arithmetic --args 65535u16 65535u16


//# run 0xDEAD::EvalOrderAndArithmeticTest::test_u16_arithmetic --args 100u16 0u16


//# run 0xDEAD::EvalOrderAndArithmeticTest::test_struct_field_access
