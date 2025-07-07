
//# publish
module 0xCAFE::AddModule {
    public fun add_and_return_fixed(a: u8, b: u8): u8 {
        let sum = a + b;
        42u8
    }

    public fun lambda_test(): u8 {
        let l: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        l(5u8, 7u8)
    }
}


//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::AddModule;

    public inline fun inline_add_then_double(x: u8, y: u8): u8 {
        let sum = AddModule::add_and_return_fixed(x, y);
        sum * 2
    }

    public fun run_nested(): u8 {
        inline_add_then_double(10u8, 5u8)
    }
}


//# run 0xCAFE::AddModule::add_and_return_fixed --args 1u8 2u8


//# run 0xCAFE::AddModule::lambda_test


//# run 0xCAFE::CallerModule::run_nested


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
