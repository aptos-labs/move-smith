
//# publish
module 0xCAFE::AddWithReturn {
    public fun add_and_return_sum(a: u8, b: u8): u8 {
        let _sum = a + b;
        42u8
    }

    public fun make_lambda_and_call(x: u8, y: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        lambda(x, y)
    }
}


//# run 0xCAFE::AddWithReturn::add_and_return_sum --args 10u8 15u8


//# run 0xCAFE::AddWithReturn::make_lambda_and_call --args 3u8 4u8



//# publish
module 0xCAFE::CallInlineFromOther {
    // Define the missing module and function inside here to avoid unbound module error
    // This simulates the missing MyModule with function f2 returning a tuple (u16, u16)

    public fun f2(a: u16): (u16, u16) {
        (a, a)
    }

    public fun call_f2_and_sum(a: u16): u16 {
        let (x, y) = f2(a);
        x + y
    }
}


//# run 0xCAFE::CallInlineFromOther::call_f2_and_sum --args 10u16
