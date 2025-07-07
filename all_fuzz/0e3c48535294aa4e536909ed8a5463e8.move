
//# publish
module 0xCAFE::Adder {
    public fun add_then_return_specific(x: u8, y: u8, ret: u8): u8 {
        let sum = x + y;
        // ignore sum and return ret to test computation before return
        ret
    }

    public fun add_with_lambda(x: u8, y: u8): u8 {
        let lambda = |a: u8, b: u8| {
            a + b
        };
        lambda(x, y)
    }
}



//# run 0xCAFE::Adder::add_then_return_specific --args 50u8 25u8 99u8



//# run 0xCAFE::Adder::add_with_lambda --args 10u8 15u8



//# publish
module 0xCAFE::NestedCaller {
    use 0xCAFE::Adder;

    public inline fun call_inline_add_with_lambda(x: u8, y: u8): u8 {
        let result = Adder::add_with_lambda(x, y);
        result
    }

    public fun runner(): u8 {
        // call inline function to test nested call and return
        call_inline_add_with_lambda(7u8, 8u8)
    }
}



//# run 0xCAFE::NestedCaller::runner
