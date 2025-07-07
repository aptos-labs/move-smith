
//# publish
module 0xCAFE::Adder {
    public fun add_then_return_fixed(a: u8, b: u8): u8 {
        let sum = a + b;
        if (sum > 10) {
            42u8
        } else {
            7u8
        }
    }

    public fun call_with_lambda(x: u8, y: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        lambda(x, y)
    }
}



//# run 0xCAFE::Adder::add_then_return_fixed --args 3u8 5u8



//# run 0xCAFE::Adder::add_then_return_fixed --args 8u8 9u8



//# run 0xCAFE::Adder::call_with_lambda --args 15u8 20u8



//# publish
module 0xCAFE::MyModule {
    public fun f2(a: u16): (u16, u16) {
        // Return a tuple of (a, a * 2) as an example
        (a, a * 2)
    }
}



//# publish
module 0xCAFE::NestedInlineCall {
    use 0xCAFE::MyModule;

    public fun nested_inline_call(a: u16): u16 {
        // Call the inline function f2 in MyModule which returns a tuple
        let (first, second) = MyModule::f2(a);
        // Add the two returned values
        first + second
    }
}



//# run 0xCAFE::NestedInlineCall::nested_inline_call --args 10u16



//# run 0xCAFE::NestedInlineCall::nested_inline_call --args 100u16
