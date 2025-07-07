
//# publish
module 0xCAFE::AddModule {
    public fun add_two_values(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 10
    }

    public fun return_lambda(): |u8, u8| u8 {
        let lambda: |u8, u8| u8 has copy + drop = |x: u8, y: u8| {
            x + y + 1
        };
        lambda
    }

    public fun call_lambda_and_use(a: u8, b: u8): u8 {
        let lam = return_lambda();
        lam(a, b)
    }

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }
}



//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::AddModule;

    public fun nested_call(a: u8, b: u8): u8 {
        let x = AddModule::inline_add(a, b);
        x + 5
    }

    public fun script_view(a: u8, b: u8): u8 {
        nested_call(a, b)
    }

    public fun complex_computation(): u8 {
        let res = 0u8;
        {
            let temp = 5u8;
            {
                let temp = temp + 3u8;
                let res = temp;
            };
            res
        }
    }
}



//# run 0xCAFE::AddModule::add_two_values --args 7u8 8u8


//# run 0xCAFE::AddModule::return_lambda


//# run 0xCAFE::AddModule::call_lambda_and_use --args 3u8 4u8


//# run 0xCAFE::CallerModule::nested_call --args 10u8 20u8


//# run 0xCAFE::CallerModule::script_view --args 11u8 12u8


//# run 0xCAFE::CallerModule::complex_computation
