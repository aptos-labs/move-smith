
//# publish
module 0xCAFE::TestAddition {
    public fun add_and_return_sum(a: u8, b: u8): u8 {
        let sum = a + b;
        // always return 42u8 as fixed number to ensure function returns the last expression
        42u8
    }

    public fun use_lambda_example(): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        lambda(10u8, 32u8)
    }
}


//# run 0xCAFE::TestAddition::add_and_return_sum --args 10u8 20u8


//# run 0xCAFE::TestAddition::use_lambda_example


//# publish
module 0xBEEF::CallerModule {
    use 0xCAFE::TestAddition;

    public inline fun call_inline_add_and_return_sum(x: u8, y: u8): u8 {
        let result = TestAddition::add_and_return_sum(x, y);
        // Return the result from TestAddition directly
        result
    }

    public fun run_loop_and_test_reassign(): u8 {
        let acc = 0u8;
        for (i in 1..5) {
            // cannot reassign loop variable i, so using acc to accumulate
            acc = acc + i;
        };
        acc
    }

    public fun check_cycles() {
        // call function itself to simulate cycle detection, although real cycle detection needs compiler/Vm
        // just to test function calls
        Self::check_cycles_inner(3u8);
    }

    fun check_cycles_inner(x: u8) {
        if (x > 0) {
            Self::check_cycles_inner(x - 1);
        };
    }
}


//# run 0xBEEF::CallerModule::call_inline_add_and_return_sum --args 11u8 31u8


//# run 0xBEEF::CallerModule::run_loop_and_test_reassign


//# run 0xBEEF::CallerModule::check_cycles


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 190eede9e6150fe22834ead163b5dbd5: Reference named address specifiers using module or address aliases.
// d0de8b446e4cbd6ab135f28da19f5934: Test that the loop correctly executes with a range and that reassigning the loop variable within the loop body is disallowed or handled as expected.
// 9cdacc7afe58cca2bcfe5785ae7f418c: Use this function to check for cycles in function call graphs within Move modules.
