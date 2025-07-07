
//# publish
module 0xCAFE::AdditionModule {
    public fun add_two_values(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 10
    }

    public fun return_closure_result(): u8 {
        let add_lambda: |u8, u8| u8 has copy + drop = |x: u8, y: u8| {
            x + y
        };
        add_lambda(2, 3)
    }

    public inline fun inline_increment(x: u8): u8 {
        x + 1
    }

    public fun nested_lambda_call(x: u8): u8 {
        let increment = |a: u8| {
            inline_increment(a)
        };
        increment(x)
    }
}



//# run 0xCAFE::AdditionModule::add_two_values --args 5u8 7u8



//# run 0xCAFE::AdditionModule::return_closure_result



//# run 0xCAFE::AdditionModule::nested_lambda_call --args 6u8



//# publish
module 0xCAFE::NestedBlocksModule {
    public fun test(): u8 {
        let x = 0u8;

        {
            let a = 1u8;
            {
                let b = 2u8;
                x = x + a + b;
            };
        };

        {
            let c = 3u8;
            {
                let d = 4u8;
                {
                    let e = 5u8;
                    x = x + c + d + e;
                };
            };
        };

        x
    }
}



//# run 0xCAFE::NestedBlocksModule::test
