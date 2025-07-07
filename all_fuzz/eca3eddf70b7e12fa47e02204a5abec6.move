
//# publish
module 0xCAFE::AddModule {
    public fun add_two_u8(x: u8, y: u8): u8 {
        let sum = x + y;
        // return sum + 10 for testing additional computation
        sum + 10
    }

    public fun lambda_example(): u8 {
        let add = |a: u8, b: u8| {
            a + b
        };
        add(7u8, 8u8)
    }
}


//# run 0xCAFE::AddModule::add_two_u8 --args 3u8 4u8


//# run 0xCAFE::AddModule::lambda_example



//# publish
module 0xCAFE::NestedCallModule {
    use 0xCAFE::AddModule;

    public inline fun inline_double(x: u8): u8 {
        x * 2
    }

    public fun call_inline_and_add(x: u8, y: u8): u8 {
        let doubled = inline_double(x);
        AddModule::add_two_u8(doubled, y)
    }
}


//# run 0xCAFE::NestedCallModule::call_inline_and_add --args 5u8 3u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
