
//# publish
module 0xCAFE::Calc {
    public fun add_and_return(a: u8, b: u8): u8 {
        let sum = a + b;
        let result = if (sum > 10) { 10 } else { sum };
        result
    }

    public fun call_lambda_with_args(x: u8, y: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        lambda(x, y)
    }

    public inline fun inline_double(a: u8): u8 {
        a * 2
    }
}



//# run 0xCAFE::Calc::add_and_return --args 5u8 8u8



//# run 0xCAFE::Calc::call_lambda_with_args --args 4u8 7u8


// Removed test running inline function directly because inline functions cannot be run as standalone functions.


//# publish
module 0xCAFE::NestedCalls {
    use 0xCAFE::Calc;

    public fun nested_call_sum_and_double(a: u8, b: u8): u8 {
        let added = Calc::add_and_return(a, b);
        let doubled = Calc::inline_double(added);
        doubled
    }

    public fun with_lambda_and_inline(a: u8, b: u8): u8 {
        let lambda: |u8| u8 has copy+drop = |x: u8| {
            Calc::inline_double(x)
        };
        let sum = Calc::add_and_return(a, b);
        lambda(sum)
    }

    public fun runner() {
        let _ = Self::nested_call_sum_and_double(3u8, 4u8);
        let _ = Self::with_lambda_and_inline(5u8, 2u8);
    }
}



//# run 0xCAFE::NestedCalls::runner
