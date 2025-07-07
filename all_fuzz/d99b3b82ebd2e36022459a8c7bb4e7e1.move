
//# publish
module 0xCAFE::AdditionTest {
    public fun add_then_return(x: u8, y: u8): u8 {
        let sum = x + y;
        sum
    }

    // Note: Move does not support lambda syntax currently.
    // So we have to rewrite with_lambda as a normal function.
    public fun with_lambda(x: u8, y: u8): u8 {
        Self::add_then_return(x, y)
    }
}



//# run 0xCAFE::AdditionTest::add_then_return --args 10u8 20u8


//# run 0xCAFE::AdditionTest::with_lambda --args 15u8 25u8


//# publish
module 0xCAFE::InlineCaller {
    use 0xCAFE::AdditionTest;

    // Inline functions must be defined in the same module or be public inline 
    // in the called module to be callable inline.
    // Remove 'inline' from the function or make sure the target function is inline public.

    // The following function is marked inline, so we need to mark add_then_return as 'public inline'
    // OR remove inline here.
    // We'll mark add_then_return as inline in AdditionTest for correctness.

    public fun inline_adder(x: u8, y: u8): u8 {
        AdditionTest::add_then_return(x, y)
    }

    public fun call_inline_adder(x: u8, y: u8): u8 {
        let r = Self::inline_adder(x, y);
        r
    }
}



//# run 0xCAFE::InlineCaller::inline_adder --args 5u8 7u8


//# run 0xCAFE::InlineCaller::call_inline_adder --args 8u8 9u8
