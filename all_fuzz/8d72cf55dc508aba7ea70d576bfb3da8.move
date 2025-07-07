
//# publish
module 0xCAFE::MyModule {
    public fun f2(a: u16): (u16, u16) {
        (a, a + 1)
    }
}


//# publish
module 0xCAFE::CalcAndInline {
    // This module tests addition and lambda expressions as well as inline function calls from another module

    public fun add_and_return_special(x: u8, y: u8): u8 {
        let sum = x + y;
        // Return 42 if sum equals 42, else return sum itself
        if (sum == 42) {
            42
        } else {
            sum
        }
    }

    public fun lambda_incrementor(): u8 {
        let inc: |u8| u8 has copy+drop = |a: u8| { a + 1 };
        inc(40)
    }

    public fun call_my_module_f2(a: u16): (u16, u16) {
        0xCAFE::MyModule::f2(a)
    }
}


//# run 0xCAFE::CalcAndInline::add_and_return_special --args 20u8 22u8


//# run 0xCAFE::CalcAndInline::add_and_return_special --args 10u8 15u8


//# run 0xCAFE::CalcAndInline::lambda_incrementor


//# run 0xCAFE::CalcAndInline::call_my_module_f2 --args 100u16
