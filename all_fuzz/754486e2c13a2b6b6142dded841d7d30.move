
//# publish
module 0xCAFE::AdditionModule {
    public fun add_and_return_special(a: u8, b: u8): u8 {
        let sum = a + b;
        if (sum == 10) {
            42u8
        } else {
            sum
        }
    }

    public fun call_lambda(a: u8, b: u8): u8 {
        let lambda: |u8, u8|u8 has copy+drop = |x: u8, y: u8| {
            x * y
        };
        lambda(a, b)
    }

    public fun call_lambda_return_tuple(a: u8, b: u8): (u8, u8) {
        let lambda: |u8, u8| (u8, u8) has copy+drop = |x: u8, y: u8| {
            let sum = x + y;
            let diff = if (x > y) { x - y } else { y - x };
            (sum, diff)
        };
        lambda(a, b)
    }

    public fun runner() {
        let _ = add_and_return_special(4u8, 6u8);
        let _ = add_and_return_special(3u8, 5u8);
        let _ = call_lambda(7u8, 8u8);
        let (_s, _d) = call_lambda_return_tuple(9u8, 6u8);
    }
}


//# run 0xCAFE::AdditionModule::add_and_return_special --args 4u8 6u8


//# run 0xCAFE::AdditionModule::add_and_return_special --args 3u8 5u8


//# run 0xCAFE::AdditionModule::call_lambda --args 7u8 8u8


//# run 0xCAFE::AdditionModule::call_lambda_return_tuple --args 9u8 6u8


//# run 0xCAFE::AdditionModule::runner


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// b734fce120b912d4adf3ea9b0f3ca979: Include 'use' declarations inside your script to import modules or symbols.
