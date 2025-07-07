
//# publish
module 0xCAFE::AdditionModule {
    const ADD_CONST: u8 = 42;

    public fun add_a_b(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + ADD_CONST
    }

    public fun lambda_example(x: u8): u8 {
        let f: |u8|u8 has copy + drop = |n: u8| {
            n + 1
        };
        f(x)
    }
}


//# publish
module 0xCAFE::InlineCallModule {
    use 0xCAFE::AdditionModule;

    public inline fun add_const_plus_one(): u8 {
        AdditionModule::add_a_b(0, 1) // should be 0+1+42 = 43
    }

    public fun call_lambda(): u8 {
        AdditionModule::lambda_example(10) // should be 11
    }

    public fun nested_call(x: u8, y: u8): u8 {
        let base = AdditionModule::add_a_b(x, y);
        add_const_plus_one() + base
    }
}


//# run 0xCAFE::AdditionModule::add_a_b --args 5u8 10u8


//# run 0xCAFE::AdditionModule::lambda_example --args 7u8


//# run 0xCAFE::InlineCallModule::add_const_plus_one


//# run 0xCAFE::InlineCallModule::call_lambda


//# run 0xCAFE::InlineCallModule::nested_call --args 1u8 2u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// f7e53e05fded97e1b2de448aadd6fab2: Declare constant values for use within modules.
