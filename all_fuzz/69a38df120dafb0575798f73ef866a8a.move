
//# publish
module 0xCAFE::AddModule {
    /// Adds two u8 values and returns the sum plus one
    public fun add_plus_one(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 1
    }

    /// Returns a lambda that adds two u8 values
    public fun get_adder_lambda(): |u8, u8| u8 has copy+drop {
        |x: u8, y: u8| {
            x + y
        }
    }

    /// Calls a lambda adding two numbers and returns result
    public fun call_adder_lambda(x: u8, y: u8): u8 {
        let adder = get_adder_lambda();
        adder(x, y)
    }
}


//# run 0xCAFE::AddModule::add_plus_one --args 5u8 10u8


//# run 0xCAFE::AddModule::call_adder_lambda --args 7u8 8u8



//# publish
module 0xCAFE::InlineCaller {
    use 0xCAFE::AddModule;

    /// Calls AddModule::add_plus_one and AddModule lambda in nested way, returns tuple of the two results
    public fun call_add_and_lambda(a: u8, b: u8): (u8, u8) {
        let result1 = AddModule::add_plus_one(a, b);
        let result2 = AddModule::call_adder_lambda(a, b);
        (result1, result2)
    }
}


//# run 0xCAFE::InlineCaller::call_add_and_lambda --args 4u8 3u8



//# publish
module 0xCAFE::VersionConfigV2 {
    /// Function explicitly specifies return type
    public fun version_two_feature(): u8 {
        // Simple return with explicit return type
        42u8
    }
}


//# run 0xCAFE::VersionConfigV2::version_two_feature


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 2cf3202470fb5be698acca1099f2f75c: Set the compiler to use version 2 features for generated code.
// 9a746c69b3deda200132aaa80170a57f: Specify return types for functions
