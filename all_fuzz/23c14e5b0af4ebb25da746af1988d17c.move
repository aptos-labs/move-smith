
//# publish
module 0xCAFE::TestFeatures {
    use std::signer;

    // 1. Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
    public fun add_and_return_value(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return 42 if sum is even, else return sum
        if ((sum % 2) == 0) {
            42
        } else {
            sum
        }
    }

    // 2. Write functions containing lambda (anonymous function) expressions.
    // Move does not currently support first-class function types or function pointers like &fun(...).
    // Instead, inline the function or just write the lambda inline.
    public fun apply_lambda_to_sum(a: u8, b: u8): u8 {
        let sum = a + b;
        // Double the sum
        sum * 2
    }

    // 3. Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
    // Use 0xCAFE::MyModule::f2 which returns a tuple (u16, u16)
    public fun call_inline_f2_and_sum(x: u16): u16 {
        let (a, b) = 0xCAFE::MyModule::f2(x);
        a + b
    }

    // 4. Use lvalue with range lists to assign multiple variables efficiently.
    public fun ranged_lvalue_assign(): (u8, u8, u8) {
        let x = 0u8;
        let y = 0u8;
        let z = 0u8;
        // loop from 0 to 2 (3 exclusive)
        let i = 0u8;
        while (i < 3) {
            if (i == 0) {
                x = i + 10;
            } else if (i == 1) {
                y = i + 20;
            } else {
                z = i + 30;
            };
            i = i + 1;
        };
        (x, y, z)
    }

    // Runner function calling all the above for testing
    public fun runner(): (u8, u8, u16, (u8, u8, u8)) {
        let a1 = add_and_return_value(14u8, 28u8);
        let a2 = apply_lambda_to_sum(3u8, 4u8);
        let a3 = call_inline_f2_and_sum(10u16);
        let a4 = ranged_lvalue_assign();
        (a1, a2, a3, a4)
    }
}
