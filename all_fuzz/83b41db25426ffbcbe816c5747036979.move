
//# publish
module 0xCAFE::AdditionModule {
    public fun add_and_return(a: u8, b: u8): u8 {
        let _sum = a + b;
        // Return some fixed value to test that code executes after addition
        42u8
    }
}



//# publish
module 0xCAFE::InlineCaller {
    use 0xCAFE::AdditionModule;

    public inline fun inline_fn(a: u8): (u8, u8) {
        (a, a + 1)
    }

    public fun caller_inline(a: u8, b: u8): u8 {
        let _result = AdditionModule::add_and_return(a, b);
        let (x, y) = inline_fn(a);
        x + y
    }
}



//# run 0xCAFE::AdditionModule::add_and_return --args 10u8 32u8



//# run 0xCAFE::InlineCaller::caller_inline --args 5u8 5u8
