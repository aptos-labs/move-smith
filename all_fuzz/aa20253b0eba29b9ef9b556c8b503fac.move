
//# publish
module 0xCAFE::CalcModule {
    // A simple function that adds two u8 numbers and returns sum + 10u8 to test arithmetic and return
    public fun add_and_offset(x: u8, y: u8): u8 {
        let sum = x + y;
        sum + 10u8
    }

    public fun run_lambda_example(): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            // simple multiply then add
            let product = a * b;
            let res = product + 5u8;
            res
        };
        lambda(3u8, 4u8)
    }

    public fun nested_lambda_runner(): u8 {
        // Lambda that takes a lambda and applies it twice
        // Corrected the lambda type syntax to use type alias (function type) syntax in Move:
        // Define the lambda without using function signature annotation (which Move does not support),
        // so just assign a closure expression directly with the appropriate parameter and return types.
        let double_apply = |f: & (u8) -> u8, x: u8| {
            f(f(x))
        };
        // Lambda that adds 2
        let add_two = |a: u8| {
            a + 2u8
        };
        double_apply(&add_two, 5u8)
    }
}



//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::CalcModule;

    // Calls the add_and_offset from CalcModule
    public fun call_add_and_offset(x: u8, y: u8): u8 {
        CalcModule::add_and_offset(x, y)
    }

    // Calls run_lambda_example from CalcModule
    public fun call_run_lambda(): u8 {
        CalcModule::run_lambda_example()
    }

    // Calls nested_lambda_runner from CalcModule
    public fun call_nested_lambda(): u8 {
        CalcModule::nested_lambda_runner()
    }

    // Inline function that calls CalcModule's add_and_offset within inlines nested calls
    public inline fun inline_call_add_and_offset(x: u8, y: u8): u8 {
        let intermediate = CalcModule::add_and_offset(x, y);
        let (a, b) = (intermediate, x);
        CalcModule::add_and_offset(a, b)
    }
}



//# run 0xCAFE::CalcModule::add_and_offset --args 5u8 7u8



//# run 0xCAFE::CalcModule::run_lambda_example



//# run 0xCAFE::CalcModule::nested_lambda_runner



//# run 0xCAFE::CallerModule::call_add_and_offset --args 10u8 15u8



//# run 0xCAFE::CallerModule::call_run_lambda



//# run 0xCAFE::CallerModule::call_nested_lambda



//# run 0xCAFE::CallerModule::inline_call_add_and_offset --args 1u8 2u8
