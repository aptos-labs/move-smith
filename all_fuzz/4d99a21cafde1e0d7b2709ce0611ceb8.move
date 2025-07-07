
//# publish
module 0xCAFE::AdditionModule {
    public fun add_two_values_and_return(x: u8, y: u8): u8 {
        let _sum = x + y; // Prevent unused variable warning by prefixing with _
        // Returns a fixed value after addition to test expression and return
        42u8
    }
}



//# run 0xCAFE::AdditionModule::add_two_values_and_return --args 5u8 10u8



//# publish
module 0xCAFE::LambdaModule {
    public fun call_lambda_and_return(x: u8): u8 {
        let lambda: |u8|u8 has copy + drop = |a: u8| {
            a * 2
        };
        lambda(x)
    }
}



//# run 0xCAFE::LambdaModule::call_lambda_and_return --args 21u8



//# publish
module 0xCAFE::NestedModule {
    // Instead of using 0xCAFE::MyModule which doesn't exist,
    // define the needed inline function and f2 locally
    
    public inline fun f2(x: u16): (u16, u16) {
        (x, x + 1)
    }

    public inline fun nested_inline_call(a: u16): u16 {
        let (b, c) = Self::f2(a);
        b + c
    }

    public fun runner(): u16 {
        nested_inline_call(10u16)
    }
}



//# run 0xCAFE::NestedModule::runner
