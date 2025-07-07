
//# publish
module 0xCAFE::AddModule {
    // This module tests addition of two u8 values and lambda expressions.

    public fun add_two(a: u8, b: u8): u8 {
        let sum = a + b;
        if (sum > 10) {
            10
        } else {
            sum
        }
    }

    public fun call_lambda(a: u8, b: u8): u8 {
        let add_fn: |u8, u8|u8 has copy+drop = |x: u8, y: u8| { x + y };
        add_fn(a, b)
    }

    public fun call_nested_lambda(x: u8): u8 {
        let inc: |u8|u8 has copy+drop = |n: u8| { n + 1 };
        let dbl: |u8|u8 has copy+drop = |n: u8| { n * 2 };

        let y = inc(x);
        dbl(y)
    }
}


//# run 0xCAFE::AddModule::add_two --args 3u8 4u8


//# run 0xCAFE::AddModule::add_two --args 7u8 5u8


//# run 0xCAFE::AddModule::call_lambda --args 6u8 7u8


//# run 0xCAFE::AddModule::call_nested_lambda --args 4u8



//# publish
module 0xCAFE::Caller {
    // Use the AddModule after it is published.
    use 0xCAFE::AddModule;

    public fun call_add_two(a: u8, b: u8): u8 {
        AddModule::add_two(a, b)
    }

    public fun call_lambda_from_add_module(a: u8, b: u8): u8 {
        AddModule::call_lambda(a, b)
    }

    public fun call_nested_functions(x: u8): u8 {
        AddModule::call_nested_lambda(x)
    }
}


//# run 0xCAFE::Caller::call_add_two --args 2u8 8u8


//# run 0xCAFE::Caller::call_lambda_from_add_module --args 10u8 1u8


//# run 0xCAFE::Caller::call_nested_functions --args 5u8
