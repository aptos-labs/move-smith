
//# publish
module 0xCAFE::AdditionModule {
    // Module to test addition and lambda usage

    public fun add_two_numbers(a: u8, b: u8): u8 {
        let sum = a + b;
        if (sum == 10) {
            100u8
        } else {
            sum
        }
    }

    public fun add_with_lambda(a: u8, b: u8): u8 {
        let add_lambda: |u8, u8|u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        add_lambda(a, b)
    }

    // A helper public function for nested calls
    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }
}


//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::AdditionModule;

    public fun call_addition(a: u8, b: u8): u8 {
        // Call inline_add from AdditionModule and then add 1 to result
        let base = AdditionModule::inline_add(a, b);
        base + 1
    }

    public fun call_add_with_lambda(a: u8, b: u8): u8 {
        AdditionModule::add_with_lambda(a, b)
    }
}


//# run 0xCAFE::AdditionModule::add_two_numbers --args 4u8 6u8


//# run 0xCAFE::AdditionModule::add_two_numbers --args 3u8 5u8


//# run 0xCAFE::AdditionModule::add_with_lambda --args 2u8 3u8


//# run 0xCAFE::CallerModule::call_addition --args 3u8 5u8


//# run 0xCAFE::CallerModule::call_add_with_lambda --args 4u8 5u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
