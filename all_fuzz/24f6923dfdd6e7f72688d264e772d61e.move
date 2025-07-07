
//# publish
module 0xCAFE::FeatureTest {
    use std::vector;

    // pragma(inline)]
    public inline fun add_u8(a: u8, b: u8): u8 {
        a + b
    }

    // pragma(inline)]
    public inline fun nested_add(a: u8, b: u8): u8 {
        let sum = add_u8(a, b);
        // Return sum + 1 to test nested inline call
        sum + 1
    }

    public fun apply_lambda(f: |u8, u8| u8, x: u8, y: u8): u8 {
        f(x, y)
    }

    // pragma(inline)]
    public inline fun return_with_subexpr(a: u8, b: u8): u8 {
        let res = (a + b) * (a - (b & 0x1));
        res
    }

    // pragma(inline)]
    public inline fun complex_type_expr(): vector<(u8, u8)> {
        let v = vector[(1u8, 2u8), (3u8, 4u8), (5u8, 6u8)];
        v
    }

    spec add_u8 {
        ensures result > 0;
    }

    spec nested_add {
        ensures result > 1;
    }

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
        let (first_x, first_y) = *vector::borrow(&vec_tt, 0);

        // Sum all results just to return a u8 value
        sum + lambda_result + nested + complex_result + first_x + first_y
    }
}


//# run 0xCAFE::FeatureTest::runner


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 4e5ab487355189f82f7efc6eefaa2ae8: Use '#[pragma ...]' annotations in your Move code to specify compiler or verifier directives.
// 946f98cb5b61645c0d2428b7312cdd18: Rewrite specifications as part of code transformations.
// 7f56308f09eac863aef51416f87aeccb: Create test expressions with sub-expressions and types.
