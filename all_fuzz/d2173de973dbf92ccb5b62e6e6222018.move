
//# publish
module 0xCAFE::ArithmeticWithLambda {

    // Define f2 inline here to replace the missing MyModule::f2
    public fun f2(a: u16): (u16, u16) {
        (a + 1, a * 2)
    }

    public fun add_then_check(a: u8, b: u8): u8 {
        let sum = a + b;
        if (sum > 100) {
            255u8
        } else {
            sum
        }
    }

    public fun call_with_lambda(x: u8, y: u8): (u8, u8) {
        let lambda: |u8, u8| (u8, u8) has copy+drop = |a: u8, b: u8| { (a + b, a * b) };
        lambda(x, y)
    }

    public fun call_inline_f2(a: u16): (u16, u16) {
        // call the local f2
        Self::f2(a)
    }
}



//# run 0xCAFE::ArithmeticWithLambda::add_then_check --args 50u8 25u8



//# run 0xCAFE::ArithmeticWithLambda::add_then_check --args 100u8 1u8



//# run 0xCAFE::ArithmeticWithLambda::call_with_lambda --args 7u8 9u8



//# run 0xCAFE::ArithmeticWithLambda::call_inline_f2 --args 11u16
