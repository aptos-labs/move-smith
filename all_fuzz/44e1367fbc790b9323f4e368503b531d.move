
//# publish
module 0xCAFE::AdditionModule {
    // Remove unused import
    // use std::signer;

    // Explicit layout annotation for struct fields
    // layout(4)]
    struct AddStruct has copy, drop, store, key {
        a: u8,
        b: u8,
    }

    // Remove friend declarations to currently unbound modules
    // friend 0xCAFE::LambdaModule;
    // friend 0xCAFE::CallerModule;

    public fun add_and_return_fixed(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return fixed value 42 after computing sum to test ordering
        42u8
    }

    public fun add_values(a: u8, b: u8): u8 {
        a + b
    }
}



//# publish
module 0xCAFE::LambdaModule {
    // Remove friend declaration of unbound CallerModule
    // friend 0xCAFE::CallerModule;

    // Lambda that adds two u8 values
    public fun sum_lambda(): |u8, u8|u8 {
        |x: u8, y: u8| {
            x + y
        }
    }

    // Lambda that multiplies two u8 values and returns the product
    public fun mul_lambda(): |u8, u8|u8 {
        |x: u8, y: u8| {
            x * y
        }
    }
}



//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::AdditionModule;
    use 0xCAFE::LambdaModule;

    // Remove friend declarations of AdditionModule and LambdaModule
    // friend 0xCAFE::AdditionModule;
    // friend 0xCAFE::LambdaModule;

    public fun nested_inline_call(a: u8, b: u8): u8 {
        let sum = AdditionModule::add_values(a, b);
        let lambda = LambdaModule::sum_lambda();
        lambda(sum, b)
    }

    public fun call_lambdas_and_add(a: u8, b: u8): u8 {
        let sum_func = LambdaModule::sum_lambda();
        let mul_func = LambdaModule::mul_lambda();
        let sum1 = sum_func(a, b);
        let product = mul_func(a, b);
        sum1 + product
    }
}



//# run 0xCAFE::AdditionModule::add_and_return_fixed --args 10u8 15u8



//# run 0xCAFE::AdditionModule::add_values --args 100u8 23u8



//# run 0xCAFE::LambdaModule::sum_lambda



//# run 0xCAFE::LambdaModule::mul_lambda



//# run 0xCAFE::CallerModule::nested_inline_call --args 5u8 7u8



//# run 0xCAFE::CallerModule::call_lambdas_and_add --args 3u8 4u8
