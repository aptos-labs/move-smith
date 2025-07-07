
//# publish
module 0xCAFE::MathWithLambda {
    public fun add_then_return(x: u8, y: u8): u8 {
        let sum = x + y;
        if (sum > 10) {
            42u8
        } else {
            7u8
        }
    }

    public fun apply_lambda_and_add(x: u8, y: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        let val = lambda(x, y);
        val + 1u8
    }

    // Added function f2 to replace MyModule::f2 in NestedCall
    public fun f2(x: u16): (u16, u16) {
        // Sample implementation: return (x, x * 2)
        (x, x * 2)
    }
}



//# run 0xCAFE::MathWithLambda::add_then_return --args 5u8 6u8



//# run 0xCAFE::MathWithLambda::apply_lambda_and_add --args 3u8 4u8



//# publish
module 0xCAFE::NestedCall {
    use 0xCAFE::MathWithLambda;

    public fun call_inline_and_compute(x: u16): u32 {
        let (a, b) = MathWithLambda::f2(x);
        let c = a + b;
        c as u32
    }

    public fun runner(): u32 {
        call_inline_and_compute(20u16)
    }
}



//# run 0xCAFE::NestedCall::call_inline_and_compute --args 15u16



//# run 0xCAFE::NestedCall::runner
