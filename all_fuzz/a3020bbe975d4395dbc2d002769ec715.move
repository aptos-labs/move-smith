
//# publish
module 0xCAFE::CalcModule {
    public fun add_two_values(x: u8, y: u8): u8 {
        let sum = x + y;
        // Return sum plus a fixed offset, e.g., 10
        sum + 10
    }

    public fun apply_lambda(x: u8, y: u8): u8 {
        let lambda: |u8, u8| u8 has copy + drop = |a: u8, b: u8| {
            a * b
        };
        lambda(x, y)
    }

    // Correct lambda syntax for no-args lambda: must use `|()` to denote no arguments
    public fun apply_lambda_no_args(): u8 {
        let lambda: || u8 has copy + drop = || {
            42u8
        };
        lambda()
    }
}




//# run 0xCAFE::CalcModule::add_two_values --args 5u8 7u8




//# run 0xCAFE::CalcModule::apply_lambda --args 6u8 8u8




//# run 0xCAFE::CalcModule::apply_lambda_no_args





//# publish
module 0xCAFE::NestedCallModule {
    // Use 'use' statement to import CalcModule functions for calls across modules
    use 0xCAFE::CalcModule;

    public inline fun inline_increment(a: u8): u8 {
        a + 1
    }

    public fun nested_calls(x: u8, y: u8): u8 {
        let partial = inline_increment(x);
        // Call CalcModule::add_two_values using the imported path
        let total = CalcModule::add_two_values(partial, y);
        total
    }
}




//# run 0xCAFE::NestedCallModule::nested_calls --args 10u8 20u8



// Features:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
