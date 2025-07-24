//# publish
module 0xCAFE::LambdaFunctions {
    public fun lambda_example() {
        let lambda: |u8, u8| (u8, u8) has copy+drop = |a: u8, b: u8| {
            let c = a + b;
            let d = a * b;
            (c, d)
        };
        let (c, d) = lambda(3u8, 4u8);

        // Copy a value that has the `copy` ability
        let another_lambda = copy lambda;
        let (_, _) = another_lambda(5u8, 6u8);
    }
}