
//# publish
module 0xCAFE::ComputeAdd {
    public fun add_then_return(a: u8, b: u8): u8 {
        let sum = a + b;
        if (sum < 100) {
            42u8
        } else {
            100u8
        }
    }

    public fun lambda_usage(): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        lambda(10u8, 20u8)
    }
}



//# run 0xCAFE::ComputeAdd::add_then_return --args 10u8 20u8



//# run 0xCAFE::ComputeAdd::lambda_usage



//# publish
module 0xCAFE::NestedCall {
    use 0xCAFE::ComputeAdd;

    public inline fun nested_inline_call(a: u8, b: u8): u8 {
        let intermediate = ComputeAdd::add_then_return(a, b);
        intermediate + ComputeAdd::lambda_usage()
    }

    public fun runner(): u8 {
        nested_inline_call(15u8, 10u8)
    }
}



//# run 0xCAFE::NestedCall::runner
