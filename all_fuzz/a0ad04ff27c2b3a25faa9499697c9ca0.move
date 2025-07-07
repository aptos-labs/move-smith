
//# publish
module 0xCAFE::LambdaTest {
    // Lambda expressions and addition checking

    public fun add_and_return(x: u8, y: u8): u8 {
        let sum = x + y;
        if (sum > 100) {
            100u8
        } else {
            sum
        }
    }

    // Move currently does not support lambda expressions or function types directly,
    // so we implement do_lambda as a normal function instead.
    public fun do_lambda(x: u8, y: u8): u8 {
        x + y
    }

    public fun runner(): u8 {
        let a = add_and_return(45u8, 30u8);
        let b = do_lambda(10u8, 15u8);
        add_and_return(a, b)
    }
}



//# publish
module 0xCAFE::NestedCalls {
    use 0xCAFE::LambdaTest;

    public fun call_inline_from_other_module(x: u8, y: u8): u8 {
        let res1 = LambdaTest::add_and_return(x, y);
        let res2 = LambdaTest::do_lambda(x, y);
        res1 + res2
    }

    public fun runner(): u8 {
        call_inline_from_other_module(20u8, 25u8)
    }
}



//# run 0xCAFE::LambdaTest::add_and_return --args 50u8 60u8


//# run 0xCAFE::LambdaTest::do_lambda --args 5u8 6u8


//# run 0xCAFE::LambdaTest::runner


//# run 0xCAFE::NestedCalls::call_inline_from_other_module --args 10u8 15u8


//# run 0xCAFE::NestedCalls::runner
