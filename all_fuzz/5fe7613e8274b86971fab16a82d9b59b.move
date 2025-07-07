
//# publish
module 0xCAFE::LambdaAdd {
    public fun add_two_numbers(a: u8, b: u8): u8 {
        let sum_lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        let sum = sum_lambda(a, b);
        // return 42 if sum equals the expected sum, else return sum
        if (sum == a + b) {
            42u8
        } else {
            sum
        }
    }
}



//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::LambdaAdd;

    public inline fun inline_adder(a: u8, b: u8): u8 {
        LambdaAdd::add_two_numbers(a, b)
    }

    public fun call_inline_adder(a: u8, b: u8): u8 {
        let result = inline_adder(a, b);
        // return result + 1 just to have a small variation
        result + 1
    }
}



//# run 0xCAFE::LambdaAdd::add_two_numbers --args 10u8 20u8



//# run 0xCAFE::CallerModule::call_inline_adder --args 10u8 20u8
