
//# publish
module 0xCAFE::AddLambdaModule {
    // Module to test addition of two u8 values and lambdas

    public fun add_two_u8(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return 42 if sum equals 42, else return sum itself
        if (sum == 42u8) {
            42u8
        } else {
            sum
        }
        // Note: removed semicolon here so the if expression value is returned
    }

    public fun lambda_adder(): |u8, u8|u8 has copy + drop {
        // Returns a lambda which adds two u8 and returns the result
        |x: u8, y: u8| {
            let result = x + y;
            // return result directly
            result
        }
    }

    public fun apply_lambda_add(x: u8, y: u8): u8 {
        let adder = lambda_adder();
        adder(x, y)
    }
}



//# run 0xCAFE::AddLambdaModule::add_two_u8 --args 20u8 22u8



//# run 0xCAFE::AddLambdaModule::add_two_u8 --args 10u8 10u8



//# run 0xCAFE::AddLambdaModule::apply_lambda_add --args 15u8 27u8



//# run 0xCAFE::AddLambdaModule::apply_lambda_add --args 1u8 2u8



//# publish
module 0xCAFE::InlineCaller {
    use 0xCAFE::AddLambdaModule;

    // Calls the inline function inside AddLambdaModule indirectly via other functions
    public inline fun add_one(x: u8): u8 {
        x + 1u8
    }

    public fun call_nested_functions(x: u8, y: u8): u8 {
        // Call inline add_one then call AddLambdaModule::add_two_u8
        let plus_one = add_one(x);
        let sum = AddLambdaModule::add_two_u8(plus_one, y);
        sum
    }

    public fun call_lambda_from_other_module(x: u8, y: u8): u8 {
        AddLambdaModule::apply_lambda_add(x, y)
    }
}



//# run 0xCAFE::InlineCaller::call_nested_functions --args 10u8 20u8



//# run 0xCAFE::InlineCaller::call_nested_functions --args 41u8 1u8



//# run 0xCAFE::InlineCaller::call_lambda_from_other_module --args 3u8 4u8



//# run 0xCAFE::InlineCaller::call_lambda_from_other_module --args 5u8 6u8
