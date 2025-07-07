
//# publish
module 0xCAFE::AdditionAndLambda {
    public fun add_and_return_special(x: u8, y: u8): u8 {
        let sum = x + y;
        if (sum < 10) {
            42u8
        } else {
            255u8
        }
    }

    public fun with_lambda(x: u8, y: u8): (u8, u8) {
        let add = |a: u8, b: u8| {
            a + b
        };
        let mul = |a: u8, b: u8| {
            a * b
        };
        (add(x, y), mul(x, y))
    }

    public fun call_lambda_param(x: u8, func: |u8|u8): u8 {
        func(x)
    }

    public fun runner_lambda(): (u8, u8) {
        with_lambda(7u8, 3u8)
    }
}


//# run 0xCAFE::AdditionAndLambda::add_and_return_special --args 3u8 4u8

//# run 0xCAFE::AdditionAndLambda::add_and_return_special --args 5u8 6u8

//# run 0xCAFE::AdditionAndLambda::with_lambda --args 4u8 5u8

//# run 0xCAFE::AdditionAndLambda::runner_lambda


// Define the module providing f2 function to replace the invalid MyModule usage


//# publish
module 0xCAFE::HelperModule {
    public fun f2(a: u16): (u16, u16) {
        (a / 2, a - (a / 2))
    }
}

// Use the correct module name below, no import of undefined module


//# publish
module 0xCAFE::CallInline {

    use 0xCAFE::HelperModule;

    public fun call_inline_double(a: u16): u16 {
        let (x1, x2) = HelperModule::f2(a);
        x1 + x2
    }

    public fun runner_call_inline(): u16 {
        call_inline_double(10u16)
    }
}


//# run 0xCAFE::CallInline::call_inline_double --args 20u16

//# run 0xCAFE::CallInline::runner_call_inline
