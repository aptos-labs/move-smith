
//# publish
module 0xCAFE::AddModule {
    public fun add_and_return_specific(x: u8, y: u8): u8 {
        let sum = x + y;
        if (sum > 10) {
            10
        } else {
            sum
        }
    }

    public fun lambda_example(x: u8, y: u8): u8 {
        let f: |u8, u8| u8 has copy+drop = |a: u8, b: u8| a + b;
        let result = f(x, y);
        result
    }

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }
}



//# publish
module 0xCAFE::NestedCall {
    use 0xCAFE::AddModule;

    public fun call_inline_and_lambda(x: u8, y: u8): u8 {
        let sum_inline = AddModule::inline_add(x, y);
        let sum_lambda = AddModule::lambda_example(x, y);
        if (sum_inline == sum_lambda) {
            sum_inline
        } else {
            0
        }
    }
}



//# run 0xCAFE::AddModule::add_and_return_specific --args 4u8 8u8



//# run 0xCAFE::AddModule::lambda_example --args 7u8 3u8



//# run 0xCAFE::NestedCall::call_inline_and_lambda --args 5u8 5u8
