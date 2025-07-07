
//# publish
module 0xCAFE::MyModule {
    public fun f2(a: u16): (u16, u16) {
        (a, a + 1)
    }
}

//# publish
module 0xCAFE::ComputeAdd {
    public fun add_then_return(n: u8, m: u8): u8 {
        let sum = n + m;
        // Return sum + 10 to distinguish from simple sum
        sum + 10
    }

    public fun call_lambda_and_return(x: u8): u8 {
        let lambda: |u8|(u8) has copy+drop = |a: u8| a + 5;
        lambda(x)
    }

    public fun nested_inline_call(a: u16): u32 {
        let (b, c) = 0xCAFE::MyModule::f2(a);
        let res = (b as u32) + (c as u32);
        res
    }

    public fun quantified_example(): u64 {
        let sum = 0u64;
        // bind list: 0..5
        for (i in 0..5) {
            sum = sum + (i as u64);
        };
        // optional expr: sum if sum > 10 else 10
        let sum = if (sum > 10) { sum } else { 10u64 };
        sum
    }
}




//# run 0xCAFE::ComputeAdd::add_then_return --args 2u8 3u8




//# run 0xCAFE::ComputeAdd::call_lambda_and_return --args 10u8




//# run 0xCAFE::ComputeAdd::nested_inline_call --args 7u16




//# run 0xCAFE::ComputeAdd::quantified_example
