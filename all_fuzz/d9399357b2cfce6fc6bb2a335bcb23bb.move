
//# publish
module 0xCAFE::AddModule {
    public fun add_two_values(x: u8, y: u8): u8 {
        let sum = x + y;
        if (sum > 100) {
            100
        } else {
            sum
        }
    }

    public fun lambda_example(): u8 {
        let add = |a: u8, b: u8| {
            a + b
        };
        add(10u8, 20u8)
    }

    // Define function f2 as expected by CallerModule
    public fun f2(x: u16): (u16, u16) {
        (x, x + 1)
    }
}



//# run 0xCAFE::AddModule::add_two_values --args 40u8 50u8



//# run 0xCAFE::AddModule::add_two_values --args 60u8 50u8



//# run 0xCAFE::AddModule::lambda_example



//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::AddModule;

    public fun call_inline_function(a: u16): u16 {
        let (r1, r2) = AddModule_inline_call(a);
        r1 + r2
    }

    fun AddModule_inline_call(x: u16): (u16, u16) {
        AddModule::f2(x)
    }
}



//# run 0xCAFE::CallerModule::call_inline_function --args 10u16
