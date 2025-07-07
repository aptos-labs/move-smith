
//# publish
module 0xCAFE::CalcModule {
    public inline fun add_u8(a: u8, b: u8): u8 {
        a + b
    }

    public fun compute_add_then_return(a: u8, b: u8): u8 {
        let sum = add_u8(a, b);
        let _ignored = sum + 1u8;
        42u8
    }

    public fun call_lambda(a: u8, b: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        lambda(a, b)
    }

    public inline fun add_then_double(a: u8, b: u8): u8 {
        let sum = add_u8(a, b);
        sum * 2
    }
}


//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::CalcModule;

    public fun nested_calls(a: u8, b: u8): u8 {
        let result = CalcModule::add_then_double(a, b);
        result
    }

    public fun call_lambda_in_caller(a: u8, b: u8): u8 {
        CalcModule::call_lambda(a, b)
    }

    public fun call_inline_add(a: u8, b: u8): u8 {
        CalcModule::add_u8(a, b)
    }
}


//# run 0xCAFE::CalcModule::compute_add_then_return --args 10u8 32u8


//# run 0xCAFE::CalcModule::call_lambda --args 10u8 11u8


//# run 0xCAFE::CallerModule::nested_calls --args 7u8 8u8


//# run 0xCAFE::CallerModule::call_lambda_in_caller --args 5u8 6u8


//# run 0xCAFE::CallerModule::call_inline_add --args 100u8 27u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// cb5a6fbd61ea12a0e989e36192ba9357: Provide an abort code or an optional module location when specifying #[expected_failure(abort_code = ...)] to indicate which abort error you expect and from which module.
