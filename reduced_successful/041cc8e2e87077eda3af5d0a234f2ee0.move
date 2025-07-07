
//# publish
module 0xCAFE::FeatureTest {
    use std::vector;

    // inline]
    public inline fun add_u8(a: u8, b: u8): u8 {
        a + b
    }

    // inline]
    public inline fun nested_add(a: u8, b: u8): u8 {
        let sum = add_u8(a, b);
        // Return sum + 1 to test nested inline call
        sum + 1
    }

    public fun apply_lambda(f: |u8, u8| u8, x: u8, y: u8): u8 {
        f(x, y)
    }

    // inline]
    public inline fun return_with_subexpr(a: u8, b: u8): u8 {
        let res = (a + b) * (a - (b & 0x1));
        res
    }

    // Define a struct to hold two u8 values instead of a tuple
    struct Pair has copy, drop, store {
        x: u8,
        y: u8,
    }

    // inline]
    public inline fun complex_type_expr(): vector<Pair> {
        let v = vector[
            Pair { x: 1u8, y: 2u8 },
            Pair { x: 3u8, y: 4u8 },
            Pair { x: 5u8, y: 6u8 }
        ];
        v
    }

    // Removed spec blocks from inline functions as it's not supported yet
    // spec add_u8 {
    //     ensures result > 0;
    // }

    // spec nested_add {
    //     ensures result > 1;
    // }

    public fun runner(): u8 {
        // Test addition function
        let sum = add_u8(10u8, 20u8);
        // Lambda function that multiplies two u8 values
        let multiply_lambda: |u8, u8| u8 has copy + drop = |a: u8, b: u8| {
            a * b
        };
        let lambda_result = apply_lambda(multiply_lambda, 3u8, 4u8);

        // Test nested inline function call
        let nested = nested_add(2u8, 3u8);

        // Test return with complex sub-expression
        let complex_result = return_with_subexpr(5u8, 3u8);

        // Use complex type expression result
        let vec_tt = complex_type_expr();
        let pair_ref = vector::borrow(&vec_tt, 0);
        let first_x = pair_ref.x;
        let first_y = pair_ref.y;

        // Sum all results just to return a u8 value
        sum + lambda_result + nested + complex_result + first_x + first_y
    }
}



//# run 0xCAFE::FeatureTest::runner
