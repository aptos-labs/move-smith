//# publish
module 0xCAFE::CalcModule {
    public fun add_two_values(x: u8, y: u8): u8 {
        x + y
    }

    public fun compute_and_return(x: u8, y: u8): u8 {
        let sum = add_two_values(x, y);
        42u8
    }

    public fun lambda_test(x: u8): u8 {
        let doubler: |u8| u8 has copy+drop = |a: u8| {
            a * 2
        };
        doubler(x)
    }
}
