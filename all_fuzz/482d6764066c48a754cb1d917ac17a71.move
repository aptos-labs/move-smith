
//# publish
module 0xCAFE::MyModule {
    // Inline function as expected by AddAndLambda::use_inline_in_nested_calls
    public inline fun f2(a: u16): (u16, u16) {
        (a, a * 2)
    }
}


//# publish
module 0xCAFE::AddAndLambda {
    // Removed unused import 'signer'

    public fun add_and_return_sum(x: u8, y: u8): u8 {
        let sum = x + y;
        sum + 1
    }

    public fun lambda_add(x: u8, y: u8): u8 {
        let add_lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        add_lambda(x, y)
    }

    // A runner function that uses inline function from another module
    public fun use_inline_in_nested_calls(a: u16): u16 {
        let (p, q) = 0xCAFE::MyModule::f2(a);
        p + q
    }

    public fun lambda_with_capture(x: u8): u8 {
        let add_x: |u8| u8 has copy+drop = |y: u8| {
            x + y
        };
        add_x(5)
    }
}




//# run 0xCAFE::AddAndLambda::add_and_return_sum --args 20u8 22u8



//# run 0xCAFE::AddAndLambda::lambda_add --args 5u8 10u8



//# run 0xCAFE::AddAndLambda::use_inline_in_nested_calls --args 10u16



//# run 0xCAFE::AddAndLambda::lambda_with_capture --args 3u8
