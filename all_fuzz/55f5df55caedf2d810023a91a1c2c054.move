
//# publish
module 0xCAFE::AddAndReturn {
    public fun add_and_return(x: u8, y: u8): u8 {
        let sum = x + y;
        if (sum > 10) {
            42u8
        } else {
            7u8
        }
    }

    public fun add_lambda(x: u8, y: u8): u8 {
        let lambda: |u8, u8| u8 = |a: u8, b: u8| {
            a + b
        };
        lambda(x, y)
    }
}



//# publish
module 0xCAFE::CallInline {
    use 0xCAFE::AddAndReturn;

    public inline fun inline_add(a: u8, b: u8): u8 {
        AddAndReturn::add_lambda(a, b)
    }

    public fun nested_call(a: u8, b: u8): u8 {
        let intermediate = inline_add(a, b);
        AddAndReturn::add_and_return(intermediate, 2u8)
    }
}



//# run 0xCAFE::AddAndReturn::add_and_return --args 6u8 5u8



//# run 0xCAFE::AddAndReturn::add_lambda --args 3u8 4u8



//# run 0xCAFE::CallInline::nested_call --args 3u8 4u8
