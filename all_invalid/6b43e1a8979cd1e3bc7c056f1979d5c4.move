
//# publish
module 0xCAFE::AdditionTest {
    public fun add_and_return_fixed(x: u8, y: u8): u8 {
        let sum = x + y;
        // returns a fixed u8 value 42 ignoring sum, just to test addition operation
        42u8
    }

    public fun run_add_and_return_fixed() {
        let _ = add_and_return_fixed(10u8, 32u8);
    }
}


//# run 0xCAFE::AdditionTest::run_add_and_return_fixed


//# publish
module 0xCAFE::LambdaTest {
    public fun apply_lambda(x: u8, y: u8): (u8, u8) {
        // lambda that adds and multiplies two u8 values
        let lambda: |u8, u8| (u8, u8) has copy+drop = |a: u8, b: u8| {
            let c = a + b;
            let d = a * b;
            (c, d)
        };
        lambda(x, y)
    }

    public fun run_apply_lambda() {
        let (_add, _mul) = apply_lambda(6u8, 7u8);
    }
}


//# run 0xCAFE::LambdaTest::run_apply_lambda


//# publish
module 0xCAFE::InlineAndNestedCall {
    use 0xCAFE::AdditionTest;

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }

    public fun nested_call_in_addition(x: u8, y: u8): u8 {
        // call AdditionTest.add_and_return_fixed and also call its own inline_add
        let fixed_res = AdditionTest::add_and_return_fixed(x, y);
        let inline_sum = inline_add(x, y);
        fixed_res + inline_sum
    }

    public fun run_nested_call() {
        let _res = nested_call_in_addition(10u8, 20u8);
    }
}


//# run 0xCAFE::InlineAndNestedCall::run_nested_call


//# publish
module 0xCAFE::CastTest {
    public fun cast_u64_to_u8_safe(x: u64): u8 {
        // cast u64 to u8 assuming x fits in u8 range
        (x as u8)
    }

    public fun cast_u128_to_u16_safe(x: u128): u16 {
        // cast u128 to u16 assuming x fits in u16 range
        (x as u16)
    }

    public fun run_casts() {
        let _a = cast_u64_to_u8_safe(200u64); // 200 fits in u8
        let _b = cast_u128_to_u16_safe(60000u128); // 60000 fits in u16

        // Intentionally perform casts with values out of range to test compiler/runtime behavior:
        // These casts might wrap silently or abort depending on environment, but here just done for coverage
        let _c = cast_u64_to_u8_safe(300u64);  // 300 > 255: overflow case
        let _d = cast_u128_to_u16_safe(100000u128); // 100000 > 65535: overflow case
    }
}


//# run 0xCAFE::CastTest::run_casts


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 39b7ee3bfddcbf2b9dc76cfba509762a: Test that casting various unsigned integer types to smaller unsigned integer types correctly preserves values within range and fails appropriately when overflowing.
