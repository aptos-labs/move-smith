
//# publish
module 0xCAFE::AdditionModule {
    public fun add_two_values(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return a fixed value if sum exceeds 10, else return sum itself
        if (sum > 10) {
            10u8
        } else {
            sum
        }
    }

    public fun run_lambda_example(a: u8, b: u8): (u8, u8) {
        // A lambda that returns addition and multiplication of two u8
        let lambda: |u8, u8| (u8, u8) has copy+drop = |x: u8, y: u8| {
            let sum = x + y;
            let product = x * y;
            (sum, product)
        };
        lambda(a, b)
    }

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }
}



//# publish
module 0xCAFE::NestedCallsModule {
    use 0xCAFE::AdditionModule;

    public fun call_inline_add_twice(a: u8, b: u8): u8 {
        let sum1 = AdditionModule::inline_add(a, b);
        let sum2 = AdditionModule::inline_add(sum1, b);
        sum2
    }
}



//# run 0xCAFE::AdditionModule::add_two_values --args 5u8 4u8



//# run 0xCAFE::AdditionModule::add_two_values --args 8u8 5u8



//# run 0xCAFE::AdditionModule::run_lambda_example --args 3u8 6u8



//# run 0xCAFE::NestedCallsModule::call_inline_add_twice --args 2u8 4u8
