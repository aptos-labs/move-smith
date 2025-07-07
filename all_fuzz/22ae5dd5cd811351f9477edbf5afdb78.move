
//# publish
module 0xCAFE::AddModule {
    public fun add_two_values(a: u8, b: u8): u8 {
        let sum = a + b;
        if (sum > 10) {
            10
        } else {
            sum
        }
    }

    public fun run_lambda_example(): u8 {
        let lambda: |u8, u8| u8 has copy + drop = |x: u8, y: u8| {
            x * y
        };
        lambda(4u8, 5u8)
    }

    public inline fun inline_increment(a: u8): u8 {
        a + 1
    }
}


//# run 0xCAFE::AddModule::add_two_values --args 3u8 4u8


//# run 0xCAFE::AddModule::add_two_values --args 7u8 8u8


//# run 0xCAFE::AddModule::run_lambda_example


//# publish
module 0xCAFE::CallInline {
    use 0xCAFE::AddModule;

    public fun call_inline_increment(a: u8): u8 {
        let incremented = AddModule::inline_increment(a);
        incremented
    }

    public fun nested_calls(a: u8, b: u8): u8 {
        let sum = AddModule::add_two_values(a, b);
        call_inline_increment(sum)
    }

    public fun runner() {
        let _ = nested_calls(5u8, 3u8);
        let _ = call_inline_increment(7u8);
    }
}


//# run 0xCAFE::CallInline::call_inline_increment --args 6u8


//# run 0xCAFE::CallInline::nested_calls --args 3u8 4u8


//# run 0xCAFE::CallInline::runner


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
