
//# publish
module 0xCAFE::LambdaAdd {
    // Module to test addition and lambda expressions

    public inline fun add_two_numbers(a: u8, b: u8): u8 {
        let sum = a + b;
        if (sum > 100) {
            100
        } else {
            sum
        }
    }

    public fun call_lambda(a: u8, b: u8): (u8, u8) {
        let lambda: |u8, u8| (u8, u8) has copy+drop = |x: u8, y: u8| {
            let sum = x + y;
            let product = x * y;
            (sum, product)
        };
        lambda(a, b)
    }
}
