
//# publish
module 0xCAFE::AddModule {
    // A simple module to test addition of two u8 values
    public fun add_two(a: u8, b: u8): u8 {
        a + b
    }

    public fun add_and_return_fixed(a: u8, b: u8): u8 {
        let sum = add_two(a, b);
        if (sum > 10) {
            42u8
        } else {
            24u8
        }
    }
}



//# run 0xCAFE::AddModule::add_and_return_fixed --args 5u8 6u8



//# run 0xCAFE::AddModule::add_and_return_fixed --args 4u8 5u8




//# publish
module 0xCAFE::LambdaModule {
    // A module to test lambda expressions

    public fun run_lambda(x: u8, y: u8): u8 {
        let my_lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            let product = a * b;
            product + 1u8
        };
        my_lambda(x, y)
    }

    public fun call_lambda_from_lambda(x: u8): u8 {
        let adder: |u8, u8| u8 has copy+drop = |a: u8, b: u8| { a + b };
        let caller: |u8| u8 has copy+drop = |n: u8| { adder(n, n) };
        caller(x)
    }
}



//# run 0xCAFE::LambdaModule::run_lambda --args 3u8 4u8



//# run 0xCAFE::LambdaModule::call_lambda_from_lambda --args 7u8




//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::AddModule;

    public fun nested_call(a: u8, b: u8): u8 {
        // Call inline function add_two from AddModule twice, sum results
        let (val1, val2) = (AddModule::add_two(a, b), AddModule::add_two(b, a));
        val1 + val2
    }
}



//# run 0xCAFE::CallerModule::nested_call --args 2u8 3u8
