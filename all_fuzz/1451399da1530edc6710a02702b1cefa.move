
//# publish
module 0xCAFE::AddModule {
    public fun add_two_u8(a: u8, b: u8): u8 {
        let sum = a + b;
        if (sum < 10) {
            100u8
        } else {
            200u8
        }
    }

    public fun sum_with_lambda(x: u8, y: u8): u8 {
        let lambda: |u8, u8|u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        lambda(x, y)
    }

    // runner without argument
    public fun run_lambda_example() {
        let f: |u8, u8|u8 has copy+drop = |x: u8, y: u8| { x + y };
        let _ = f(5u8, 6u8);
    }
}



//# run 0xCAFE::AddModule::add_two_u8 --args 3u8 4u8



//# run 0xCAFE::AddModule::sum_with_lambda --args 7u8 5u8



//# run 0xCAFE::AddModule::run_lambda_example



//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::AddModule;

    public fun call_inline_sum(a: u8, b: u8): u8 {
        AddModule::sum_with_lambda(a, b)
    }

    public fun call_nested_inline(a: u8, b: u8): u8 {
        let res = call_inline_sum(a, b);
        res + 1u8
    }
}



//# run 0xCAFE::CallerModule::call_inline_sum --args 2u8 3u8



//# run 0xCAFE::CallerModule::call_nested_inline --args 2u8 3u8


// Features:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
