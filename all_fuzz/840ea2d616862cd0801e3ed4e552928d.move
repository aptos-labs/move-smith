
//# publish
module 0xCAFE::AddModule {
    // Module to test addition and inline function calls

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }

    public fun add_two_and_return_sum(x: u8, y: u8): u8 {
        let sum = inline_add(x, y);
        // return sum + 1
        sum + 1
    }

    // Function that matches |u8| u8 signature for the apply_lambda test
    public fun double(x: u8): u8 {
        x * 2
    }

    // Function containing a lambda/anonymous function that doubles input
    public fun double_with_lambda(x: u8): u8 {
        let f: |u8| u8 has copy+drop = |v: u8| { v * 2 };
        f(x)
    }

    // Function that uses let binding with multiple variables from function output
    public fun multiple_bindings(): (u8, u8) {
        let (a, b) = (3u8, 4u8);
        (a, b)
    }

    // Function accepting a lambda/function pointer and a u8 and calls the lambda
    public fun apply_lambda(f: |u8| u8, x: u8): u8 {
        f(x)
    }
}



//# run 0xCAFE::AddModule::add_two_and_return_sum --args 10u8 20u8



//# run 0xCAFE::AddModule::double_with_lambda --args 15u8



//# run 0xCAFE::AddModule::multiple_bindings



//# run 0xCAFE::AddModule::apply_lambda --args "0xCAFE::AddModule::double" 7u8



//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::AddModule;

    public fun call_inline_add(x: u8, y: u8): u8 {
        // Call AddModule::inline_add
        AddModule::inline_add(x, y) + 5
    }

    public fun call_add_two_and_return_sum(x: u8, y: u8): u8 {
        AddModule::add_two_and_return_sum(x, y)
    }

    // Call AddModule's apply_lambda with a lambda that adds 3 to input
    public fun call_apply_lambda(x: u8): u8 {
        let lambda: |u8| u8 has copy+drop = |v: u8| { v + 3 };
        AddModule::apply_lambda(lambda, x)
    }

    // Function that binds multiple variables from call to multiple_bindings
    public fun bind_multiple_from_other(): (u8, u8) {
        let (a, b) = AddModule::multiple_bindings();
        (a + 1, b + 1)
    }
}



//# run 0xCAFE::CallerModule::call_inline_add --args 1u8 2u8



//# run 0xCAFE::CallerModule::call_add_two_and_return_sum --args 4u8 5u8



//# run 0xCAFE::CallerModule::call_apply_lambda --args 10u8



//# run 0xCAFE::CallerModule::bind_multiple_from_other
