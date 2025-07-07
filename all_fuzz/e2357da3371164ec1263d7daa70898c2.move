
//# publish
module 0xCAFE::LambdaTest {
    public fun add_and_return_fixed(a: u8, b: u8): u8 {
        let sum = a + b;
        let lambda: |u8| u8 has copy+drop = |x: u8| {
            x + 1
        };
        let _ = lambda(sum);
        42u8
    }

    public fun lambda_example() {
        let f: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        let _result = f(10u8, 15u8);
    }
}


//# run 0xCAFE::LambdaTest::add_and_return_fixed --args 10u8 20u8


//# run 0xCAFE::LambdaTest::lambda_example



//# publish
module 0xCAFE::Caller {
    use 0xCAFE::LambdaTest;

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }

    public fun call_inline_and_lambda(a: u8, b: u8): u8 {
        let sum = inline_add(a, b);
        let res = LambdaTest::add_and_return_fixed(sum, 1u8);
        res
    }
}


//# run 0xCAFE::Caller::call_inline_and_lambda --args 5u8 6u8



//# publish
module 0xCAFE::OverrideTest {
    const VALUE: u8 = 1;
    const VALUE: u8 = 2;
    const VALUE: u8 = 3;

    public fun get_value(): u8 {
        VALUE
    }

    const ANOTHER: u8 = 10;
    const ANOTHER: u8 = 20;
    const ANOTHER: u8 = 30;

    public fun get_another(): u8 {
        ANOTHER
    }
}


//# run 0xCAFE::OverrideTest::get_value


//# run 0xCAFE::OverrideTest::get_another


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// ddec74699b6b377bdc840c7840ed3584: Use multiple entries for the same experiment to override previous settings, with later entries taking precedence.
