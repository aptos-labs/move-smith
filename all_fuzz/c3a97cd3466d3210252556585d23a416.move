
//# publish
module 0xCAFE::LambdaAndInlineTest {

    // Define the inline function f2 within this module instead of referencing MyModule::f2
    public inline fun f2(a: u16): (u16, u16) {
        // For demonstration, just return (a * 2, a + 3) or any simple calculation
        (a * 2, a + 3)
    }

    public fun add_and_return_sum(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return sum plus 10 to produce a specific value
        sum + 10
    }

    public fun use_lambda(a: u8, b: u8): (u8, u8) {
        let lambda: |u8, u8| (u8, u8) has copy+drop = |x: u8, y: u8| {
            let sum = x + y;
            let prod = x * y;
            (sum, prod)
        };
        lambda(a, b)
    }

    public fun nested_inline_call(a: u16): u16 {
        let (val1, val2) = f2(a);
        // Return the sum of both values from the inline function call
        val1 + val2
    }

    public fun run_all_tests(): u8 {
        let add_result = add_and_return_sum(4u8, 5u8);
        let (lam_sum, lam_prod) = use_lambda(3u8, 7u8);
        let inline_call_result = nested_inline_call(10u16);

        // Use some dummy computation involving all results to enforce usage
        add_result + lam_sum + lam_prod + (inline_call_result as u8)
    }
}



//# run 0xCAFE::LambdaAndInlineTest::add_and_return_sum --args 7u8 8u8



//# run 0xCAFE::LambdaAndInlineTest::use_lambda --args 5u8 6u8



//# run 0xCAFE::LambdaAndInlineTest::nested_inline_call --args 20u16



//# run 0xCAFE::LambdaAndInlineTest::run_all_tests
