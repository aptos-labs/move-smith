
//# publish
module 0xCAFE::AdditionModule {
    public fun add_and_return_special(x: u8, y: u8): u8 {
        let sum = x + y;
        if (sum > 10) {
            // Return 42 if sum is greater than 10
            42
        } else {
            // Return the sum otherwise
            sum
        }
    }

    public fun lambda_test(): u8 {
        let adder: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        let result = adder(5u8, 3u8);
        result
    }

    public inline fun inline_adder(a: u8, b: u8): u8 {
        a + b
    }
}


//# run 0xCAFE::AdditionModule::add_and_return_special --args 7u8 6u8


//# run 0xCAFE::AdditionModule::lambda_test


//# publish
module 0xCAFE::NestedCaller {
    use 0xCAFE::AdditionModule;

    public fun call_inline_adder(a: u8, b: u8): u8 {
        AdditionModule::inline_adder(a, b)
    }

    public fun call_add_and_with_return(x: u8, y: u8): u8 {
        let sum = x + y;
        if (sum < 5) {
            return 0;
        };
        AdditionModule::add_and_return_special(x, y)
    }
}


//# run 0xCAFE::NestedCaller::call_inline_adder --args 4u8 5u8


//# run 0xCAFE::NestedCaller::call_add_and_with_return --args 2u8 2u8


//# run 0xCAFE::NestedCaller::call_add_and_with_return --args 7u8 6u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// a16a6c9869c23dafcdafa035bd0cf5e4: Return values from functions using the 'return' statement
