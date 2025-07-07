
//# publish
module 0xCAFE::TestAddLambda {
    /// Adds two u8 numbers and returns the sum plus a fixed number 10.
    public fun add_and_offset(a: u8, b: u8): u8 {
        let sum = a + b;
        let result = sum + 10u8;
        result
    }

    /// Demonstrates lambda usage: applies a lambda that multiplies by 2 on input u8.
    public fun apply_double_lambda(x: u8): u8 {
        let double_lambda: |u8| u8 has copy+drop = |val: u8| {
            val * 2u8
        };
        double_lambda(x)
    }

    /// A runner function that exercises all above functions without args.
    public fun runner() {
        let _ = add_and_offset(5u8, 7u8);
        let _ = apply_double_lambda(11u8);
    }
}


//# run 0xCAFE::TestAddLambda::add_and_offset --args 11u8 22u8


//# run 0xCAFE::TestAddLambda::apply_double_lambda --args 5u8


//# run 0xCAFE::TestAddLambda::runner
