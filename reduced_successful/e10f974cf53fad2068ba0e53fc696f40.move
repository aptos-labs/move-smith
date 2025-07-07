
//# publish
module 0xCAFE::LambdaModule {
    /// This module tests lambda functions and inline function calls

    public inline fun inline_add(a: u64, b: u64): u64 {
        a + b
    }

    public fun call_lambda_and_inline(x: u64, y: u64): u64 {
        // Lambda expression adds 3 to input and then adds y
        let lambda: |u64|u64 has copy+drop = |v: u64| {
            inline_add(v, 3u64)
        };
        let intermediate = lambda(x);
        inline_add(intermediate, y)
    }

    public fun run_lambda() {
        let adder: |u8, u8| (u8, u8) has copy+drop = |a: u8, b: u8| {
            (a + b, a * b)
        };
        let (sum, product) = adder(5u8, 7u8);
    }

    public fun runner() {
        let _ = call_lambda_and_inline(1u64, 2u64);
        run_lambda();
    }
}


//# run 0xCAFE::LambdaModule::runner


//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::LambdaModule;

    public fun invoke_inline_add(a: u64, b: u64): u64 {
        LambdaModule::inline_add(a, b)
    }

    public fun invoke_call_lambda_and_inline(a: u64, b: u64): u64 {
        LambdaModule::call_lambda_and_inline(a, b)
    }

    public fun runner() {
        let _ = invoke_inline_add(10u64, 20u64);
        let _ = invoke_call_lambda_and_inline(5u64, 5u64);
    }
}


//# run 0xCAFE::CallerModule::runner


//# publish
module 0xCAFE::SELF_NAME {
    // This module name uses reserved-like name SELF_NAME to test that it can be compiled and published.

    public fun dummy() {
    }
}


//# run 0xCAFE::SELF_NAME::dummy


// Featurres:
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 1d77a63b6a1acc3e0bf1e0bc388ca635: Use reserved names for modules or aliases, such as 'SELF_NAME', to prevent their usage as identifiers.
