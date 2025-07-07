
//# publish
module 0xCAFE::MyModule {
    public fun f2(x: u16): (u16, u16) {
        // Some example implementation of f2
        (x + 1, x + 2)
    }
}

//# publish
module 0xCAFE::CalcModule {
    public fun add_and_double(x: u8, y: u8): u8 {
        let sum = x + y;
        let double_sum = sum * 2;
        double_sum
    }

    public fun use_lambda_example(): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a * b + 1u8
        };
        lambda(3u8, 4u8)
    }

    public fun call_inline_twice(a: u16): u16 {
        let (val1, _val2) = 0xCAFE::MyModule::f2(a);
        let (val3, _) = 0xCAFE::MyModule::f2(val1);
        val3
    }
}



//# run 0xCAFE::CalcModule::add_and_double --args 5u8 8u8



//# run 0xCAFE::CalcModule::use_lambda_example



//# run 0xCAFE::CalcModule::call_inline_twice --args 10u16

// Features:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
