
//# publish
module 0xCAFE::LambdaModule {
    public fun add_two_u8(x: u8, y: u8): u8 {
        let _sum = x + y;
        // Return a fixed number after addition to check flow
        42u8
    }

    // Note: Changed to public inline for cross-module lambda usage
    public inline fun lambda_identity_lambda(x: u8): u8 {
        let identity: |u8|u8 has copy+drop = |x: u8| {
            x
        };
        identity(x)
    }

    // Note: Changed to public inline for cross-module lambda usage
    public inline fun lambda_add_multiply(x: u8, y: u8): (u8, u8) {
        let lambda: |u8, u8| (u8, u8) has copy+drop = |a: u8, b: u8| {
            let sum = a + b;
            let product = a * b;
            (sum, product)
        };
        lambda(x, y)
    }
}



//# publish
module 0xCAFE::InlineCaller {
    use 0xCAFE::LambdaModule;

    public inline fun inline_double_add(a: u8, b: u8): u8 {
        // call add_two_u8 twice and sum results (will be fixed 42 + 42)
        let first = LambdaModule::add_two_u8(a, b);
        let second = LambdaModule::add_two_u8(b, a);
        first + second
    }

    public inline fun call_lambda_functions(x: u8, y: u8): (u8, u8, u8) {
        // Call public inline functions from LambdaModule
        let id_result = LambdaModule::lambda_identity_lambda(x);
        let (sum, product) = LambdaModule::lambda_add_multiply(x, y);
        (id_result, sum, product)
    }
}



//# run 0xCAFE::LambdaModule::add_two_u8 --args 10u8 32u8



//# run 0xCAFE::LambdaModule::lambda_identity_lambda --args 77u8



//# run 0xCAFE::LambdaModule::lambda_add_multiply --args 5u8 9u8



//# run 0xCAFE::InlineCaller::inline_double_add --args 5u8 7u8



//# run 0xCAFE::InlineCaller::call_lambda_functions --args 4u8 6u8
