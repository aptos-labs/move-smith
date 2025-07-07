
//# publish
module 0xCAFE::AdditionWithLambda {
    // Removed unused "use std::signer;"

    public fun add_two_values(a: u8, b: u8): u8 {
        a + b
    }

    public fun lambda_example(x: u8, y: u8): u8 {
        let add_lambda: |u8, u8|u8 has copy+drop = |a: u8, b: u8| { a + b };
        add_lambda(x, y)
    }

    // Since 0xCAFE::MyModule::f2 is not defined anywhere, either define it here or remove this function.
    // I'll define a stub inline 'f2' in this module to fix the linker error.
    public fun f2(x: u16): (u16, u16) {
        // dummy implementation for testing
        (x, x + 1)
    }

    public fun nested_inline_call(x: u16): u16 {
        let (a, b) = f2(x);
        a + b
    }

    // test]
    public fun test_add_two_values() {
        let res = add_two_values(10u8, 5u8);
        let _ = if (res == 15u8) { 0u8 } else { abort 1 };
    }

    // test]
    // expected_failure(location: 0xCAFE)]
    public fun test_lambda_example() {
        let res = lambda_example(1u8, 2u8);
        let _ = if (res == 3u8) { 0u8 } else { abort 2 };
    }
}
