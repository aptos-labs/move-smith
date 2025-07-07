
//# publish
module 0xCAFE::MyModule {
    public fun f2(a: u16): (u16, u16) {
        // example implementation splitting the number into two parts
        (a / 2, a - (a / 2))
    }
}

//# publish
module 0xCAFE::AddAndLambda {
    public fun add_and_return_special(a: u8, b: u8): u8 {
        let sum = a + b;
        if (sum > 10) {
            42u8
        } else {
            24u8
        }
    }

    public fun call_lambda(a: u8, b: u8): u8 {
        let adder: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        adder(a, b)
    }

    public fun call_inline_and_lambda(a: u16): (u16, u16, u8) {
        // call inline function from 0xCAFE::MyModule
        let (first, second) = 0xCAFE::MyModule::f2(a);
        let lambda: |u8| u8 has copy+drop = |x: u8| { x + 1 };
        let lambda_result = lambda((first as u8) + (second as u8));
        (first, second, lambda_result)
    }
}



//# run 0xCAFE::AddAndLambda::add_and_return_special --args 3u8 5u8


//# run 0xCAFE::AddAndLambda::add_and_return_special --args 6u8 6u8


//# run 0xCAFE::AddAndLambda::call_lambda --args 10u8 15u8


//# run 0xCAFE::AddAndLambda::call_inline_and_lambda --args 5u16
