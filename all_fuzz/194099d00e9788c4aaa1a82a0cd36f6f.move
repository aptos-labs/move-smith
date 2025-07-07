
//# publish
module 0xCAFE::MyModule {
    public fun f2(c: u16): (u16, u16) {
        // For simplicity, return c and c * 2 as a tuple
        (c, c * 2)
    }
}

//# publish
module 0xCAFE::TestAdd {
    public fun add_then_return_fixed(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return fixed value 42 to test computation and return consistency
        42
    }

    public fun test_lambda_usage(a: u8, b: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        lambda(a, b)
    }

    public fun get_sum_using_inline(c: u16): u16 {
        let (x, y) = 0xCAFE::MyModule::f2(c);
        x + y
    }
}



//# run 0xCAFE::TestAdd::add_then_return_fixed --args 10u8 20u8



//# run 0xCAFE::TestAdd::test_lambda_usage --args 15u8 27u8



//# run 0xCAFE::TestAdd::get_sum_using_inline --args 100u16


// Features:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
