
//# publish
module 0xCAFE::MyModule {
    public fun f2(x: u16): (u16, u16) {
        (x, x + 1)
    }
}

//# publish
module 0xCAFE::AddAndLambda {
    public fun add_then_return(a: u8, b: u8): u8 {
        let sum = a + b;
        if (sum > 10) {
            42u8
        } else {
            1u8
        }
    }

    public fun lambda_test(x: u8): u8 {
        let add_lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| { a + b };
        add_lambda(x, 2u8)
    }

    public fun nested_calls(x: u16): u16 {
        let (a, b) = 0xCAFE::MyModule::f2(x);
        a + b
    }
}



//# run 0xCAFE::AddAndLambda::add_then_return --args 5u8 9u8



//# run 0xCAFE::AddAndLambda::lambda_test --args 10u8



//# run 0xCAFE::AddAndLambda::nested_calls --args 3u16
