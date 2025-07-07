
//# publish
module 0xCAFE::AdditionWithCheck {
    public fun add_then_check(a: u8, b: u8): u8 {
        let sum = a + b;
        if (sum > 200) {
            255
        } else {
            sum
        }
    }

    public fun return_lambda_sum(): u8 {
        let adder: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        adder(10u8, 20u8)
    }
}



//# run 0xCAFE::AdditionWithCheck::add_then_check --args 100u8 70u8


//# run 0xCAFE::AdditionWithCheck::add_then_check --args 150u8 60u8


//# run 0xCAFE::AdditionWithCheck::return_lambda_sum



//# publish
module 0xCAFE::WrapperModule {
    use 0xCAFE::AdditionWithCheck;

    // Call the inline function from AdditionWithCheck module to get sum + 1
    public fun call_and_increment(a: u8, b: u8): u8 {
        let sum = AdditionWithCheck::add_then_check(a, b);
        sum + 1
    }

    // Call lambda returning function in AdditionWithCheck module
    public fun call_lambda(): u8 {
        AdditionWithCheck::return_lambda_sum()
    }
}



//# run 0xCAFE::WrapperModule::call_and_increment --args 50u8 100u8


//# run 0xCAFE::WrapperModule::call_lambda
