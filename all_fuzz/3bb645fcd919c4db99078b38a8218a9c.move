
//# publish
module 0xCAFE::AddModule {
    public fun add_two_values(x: u8, y: u8): u8 {
        let sum = x + y;
        let result = sum + 10;
        result
    }

    public fun lambda_example(x: u8): u8 {
        let add_five = |a: u8| {
            a + 5
        };
        add_five(x)
    }
}


//# run 0xCAFE::AddModule::add_two_values --args 3u8 7u8


//# run 0xCAFE::AddModule::lambda_example --args 10u8


//# publish
module 0xCAFE::NestedCallModule {
    use 0xCAFE::AddModule;

    public inline fun inline_add(x: u8, y: u8): u8 {
        AddModule::add_two_values(x, y)
    }

    public fun nested_call(): u8 {
        let a = 4u8;
        let b = 6u8;
        let result = inline_add(a, b);
        result
    }
}


//# run 0xCAFE::NestedCallModule::nested_call


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
