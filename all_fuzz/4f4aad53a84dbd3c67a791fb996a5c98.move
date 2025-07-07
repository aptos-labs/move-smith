
//# publish
module 0xCAFE::AddModule {
    // Module to test addition and lambda functions

    public fun add_two_values(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return sum + 10 to check function modifies output
        sum + 10
    }

    public fun lambda_add(a: u8, b: u8): u8 {
        let add_lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| { x + y };
        add_lambda(a, b)
    }

    public fun lambda_double(a: u8): u8 {
        let double_lambda: |u8| u8 has copy+drop = |x: u8| { x * 2 };
        double_lambda(a)
    }
}


//# publish
module 0xCAFE::MyModule {
    public inline fun f2(x: u16): (u16, u16) {
        (x, x * 2)
    }
}


//# publish
module 0xCAFE::CallerModule {
    // Remove unused use statement
    // use 0xCAFE::AddModule;  // Removed due to unused alias warning

    public fun call_inline_function(a: u16): (u16, u16) {
        // Calls MyModule::f2 inline function through AddModule's nested call
        nested_call_inline(a)
    }

    public inline fun nested_call_inline(x: u16): (u16, u16) {
        // Directly call MyModule::f2 inline function here for nested call test
        0xCAFE::MyModule::f2(x)
    }
}



//# run 0xCAFE::AddModule::add_two_values --args 5u8 7u8



//# run 0xCAFE::AddModule::lambda_add --args 3u8 4u8



//# run 0xCAFE::AddModule::lambda_double --args 6u8



//# run 0xCAFE::CallerModule::call_inline_function --args 11u16
