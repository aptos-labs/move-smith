
//# publish
module 0xCAFE::MathOps {
    const InitialValue: u8 = 10;

    public inline fun add(a: u8, b: u8): u8 {
        a + b
    }

    public fun add_and_increment(a: u8, b: u8): u8 {
        let sum = add(a, b);
        sum + InitialValue
    }

    public fun run_lambda_example(x: u8): u8 {
        let add_one: |u8|u8 has copy+drop = |v: u8| { v + 1 };
        let doubled: |u8|u8 has copy+drop = |v: u8| { v * 2 };
        let added = add_one(x);
        let result = doubled(added);
        result
    }
}


//# run 0xCAFE::MathOps::add_and_increment --args 3u8 4u8


//# run 0xCAFE::MathOps::run_lambda_example --args 5u8


//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::MathOps;

    public fun nested_call_example(a: u8, b: u8): u8 {
        let result = MathOps::add_and_increment(a, b);
        result
    }

    public inline fun inline_wrapper(a: u8, b: u8): u8 {
        MathOps::add(a, b)
    }

    public fun call_inline_from_function(a: u8, b: u8): u8 {
        inline_wrapper(a, b)
    }
}


//# run 0xCAFE::CallerModule::nested_call_example --args 2u8 3u8


//# run 0xCAFE::CallerModule::call_inline_from_function --args 7u8 8u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 24df415c35991088eee1994840d9775c: Create inline functions that can be called from within other functions.
// 33a822d31d9a501c5ed6c5bdebc0581a: Name struct constants or schemas with an initial uppercase ASCII letter
