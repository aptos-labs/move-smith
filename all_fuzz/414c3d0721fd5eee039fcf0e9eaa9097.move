
//# publish
module 0xCAFE::MyModule {
    public fun f2(x: u16): u16 {
        x * 2
    }
}


//# publish
module 0xCAFE::AddAndLambda {
    public fun add_and_return_special(x: u8, y: u8): u8 {
        let sum = x + y;
        if (sum > 10) {
            42u8
        } else {
            24u8
        }
    }

    public fun call_lambda_and_return(x: u8, y: u8): u8 {
        let lambda: |u8, u8| u8 has copy + drop = |a: u8, b: u8| {
            a + b
        };
        let result = lambda(x, y);
        result
    }

    public fun nested_inline_call(x: u16): u16 {
        0xCAFE::MyModule::f2(x) + 1u16
    }
}




//# run 0xCAFE::AddAndLambda::add_and_return_special --args 5u8 6u8




//# run 0xCAFE::AddAndLambda::add_and_return_special --args 3u8 4u8




//# run 0xCAFE::AddAndLambda::call_lambda_and_return --args 7u8 8u8




//# run 0xCAFE::AddAndLambda::nested_inline_call --args 10u16
