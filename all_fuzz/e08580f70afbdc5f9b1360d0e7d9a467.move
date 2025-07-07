
//# publish
module 0xCAFE::AdditionModule {
    public fun add_then_return_special(a: u8, b: u8): u8 {
        let sum = a + b;
        if (sum == 10) {
            42u8
        } else {
            sum
        }
    }

    public fun lambda_example(x: u8, y: u8): (u8, u8) {
        let add = |a: u8, b: u8| { a + b };
        let mul = |a: u8, b: u8| { a * b };
        let sum = add(x, y);
        let product = mul(x, y);
        (sum, product)
    }
}


//# run 0xCAFE::AdditionModule::add_then_return_special --args 5u8 5u8


//# run 0xCAFE::AdditionModule::add_then_return_special --args 7u8 1u8


//# run 0xCAFE::AdditionModule::lambda_example --args 3u8 4u8



//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::AdditionModule;

    public inline fun inline_func(x: u8): u8 {
        x + 1
    }

    public fun call_nested_functions(a: u8, b: u8): u8 {
        let sum_from_addition_module = AdditionModule::add_then_return_special(a, b);
        let incremented = inline_func(sum_from_addition_module);
        incremented
    }
}


//# run 0xCAFE::CallerModule::call_nested_functions --args 4u8 6u8

//# run 0xCAFE::CallerModule::call_nested_functions --args 1u8 2u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
