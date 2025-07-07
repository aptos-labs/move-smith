
//# publish
module 0xCAFE::CalcModule {
    // A simple calculator module to test addition and inline function calls

    public inline fun add_u8(a: u8, b: u8): u8 {
        a + b
    }

    public fun compute_sum_plus_one(a: u8, b: u8): u8 {
        let sum = add_u8(a, b);
        sum + 1
    }

    public fun compute_with_lambda(a: u8, b: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        lambda(a, b)
    }

    public fun call_inline_add_twice(a: u8, b: u8): u8 {
        let first = add_u8(a, b);
        let second = add_u8(first, first);
        second
    }
}


//# run 0xCAFE::CalcModule::compute_sum_plus_one --args 10u8 20u8


//# run 0xCAFE::CalcModule::compute_with_lambda --args 15u8 25u8


//# run 0xCAFE::CalcModule::call_inline_add_twice --args 2u8 3u8


//# publish
module 0xCAFE::NestedCallModule {
    use 0xCAFE::CalcModule;

    public fun call_calc_add_and_increase(a: u8, b: u8): u8 {
        let intermediate_result = CalcModule::add_u8(a, b);
        CalcModule::compute_sum_plus_one(intermediate_result, 0u8)
    }

    public fun call_lambda_via_calc(a: u8, b: u8): u8 {
        CalcModule::compute_with_lambda(a, b)
    }
}


//# run 0xCAFE::NestedCallModule::call_calc_add_and_increase --args 5u8 10u8


//# run 0xCAFE::NestedCallModule::call_lambda_via_calc --args 7u8 8u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
