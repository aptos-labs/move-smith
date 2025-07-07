
//# publish
module 0xCAFE::LambdaModule {
    // Module to test lambda expressions and addition of u8 values

    public fun add_and_return_sum(a: u8, b: u8): u8 {
        let sum = a + b;

        let check_sum: |u8| u8 has copy+drop = |x: u8| {
            if (x == sum) {
                42u8
            } else {
                0u8
            }
        };
        check_sum(sum)
    }

    public fun run_lambda_examples() {
        let double: |u8| u8 has copy = |x: u8| { x * 2 };
        let triple: |u8| u8 has copy = |x: u8| { x * 3 };
        let d = double(10u8);
        let t = triple(10u8);

        let compose: |u8| u8 has copy = |x: u8| {
            let a = double(x);
            triple(a)
        };
        let _ = compose(5u8);
    }
}


//# run 0xCAFE::LambdaModule::add_and_return_sum --args 20u8 22u8


//# run 0xCAFE::LambdaModule::run_lambda_examples



//# publish
module 0xCAFE::NestedCallModule {
    use 0xCAFE::LambdaModule;

    public inline fun inline_add(a: u16, b: u16): u16 {
        a + b
    }

    public fun nested_calls(x: u8, y: u8): u8 {
        // Call the add_and_return_sum function in LambdaModule
        let result1 = LambdaModule::add_and_return_sum(x, y);

        // Call inline function inline_add with cast of u8 to u16
        let inline_result = inline_add(x as u16, y as u16);

        // Use result from inline function and result1 for a combined return value
        if (inline_result > 100u16) {
            result1
        } else {
            255u8
        }
    }
}


//# run 0xCAFE::NestedCallModule::nested_calls --args 40u8 15u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
