
//# publish
module 0xCAFE::MyModule {
    public inline fun f2(a: u16): (u16, u16) {
        (a, a + 1)
    }
}

//# publish
module 0xCAFE::LambdaTest {
    public fun add_two_values(a: u8, b: u8): u8 {
        a + b
    }

    public fun use_lambda_addition(): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        lambda(7u8, 8u8)
    }

    public fun call_inline_from_other_module(a: u16): u16 {
        let (res1, res2) = 0xCAFE::MyModule::f2(a);
        res1 + res2
    }
}



//# run 0xCAFE::LambdaTest::add_two_values --args 10u8 15u8



//# run 0xCAFE::LambdaTest::use_lambda_addition



//# run 0xCAFE::LambdaTest::call_inline_from_other_module --args 5u16


// Features:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
