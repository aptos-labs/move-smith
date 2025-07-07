
//# publish
module 0xCAFE::MathOperations {
    // Functions to test u8 addition and lambda usage

    public fun add_two_values(a: u8, b: u8): u8 {
        let sum = a + b;
        // returns sum + 10u8 to have a specific result different than just sum
        sum + 10u8
    }

    public fun apply_lambda(x: u8, y: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b + 5u8
        };
        lambda(x, y)
    }
}


//# publish
module 0xCAFE::HelperModule {
    /// A replacement for `MyModule`, which does not exist
    /// Provides function `f2` that returns two increments of input
    public fun f2(val: u16): (u8, u8) {
        let inc1 = (val + 1) as u8;
        let inc2 = (val + 2) as u8;
        (inc1, inc2)
    }
}


//# publish
module 0xCAFE::CrossModuleCalls {
    use 0xCAFE::HelperModule;
    use 0xCAFE::MathOperations;

    public fun nested_inline_call(val: u16): u16 {
        let (inc1, inc2) = HelperModule::f2(val);
        let sum = inc1 + inc2;
        let result = MathOperations::add_two_values(sum, 5u8);
        result as u16
    }

    public fun lambda_and_inline_call(x: u8, y: u8): u8 {
        let res1 = MathOperations::apply_lambda(x, y);
        let res2 = MathOperations::add_two_values(res1, 2u8);
        res2
    }
}



//# run 0xCAFE::MathOperations::add_two_values --args 10u8 20u8


//# run 0xCAFE::MathOperations::apply_lambda --args 3u8 7u8


//# run 0xCAFE::CrossModuleCalls::nested_inline_call --args 100u16


//# run 0xCAFE::CrossModuleCalls::lambda_and_inline_call --args 4u8 6u8
