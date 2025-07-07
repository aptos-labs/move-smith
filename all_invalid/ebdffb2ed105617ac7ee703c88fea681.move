
//# publish
module 0xCAFE::TestAdd {
    public fun add_and_return_flag(x: u8, y: u8): u8 {
        let sum = x + y;
        if (sum > 10) {
            1u8
        } else {
            0u8
        };
    }
}


//# run 0xCAFE::TestAdd::add_and_return_flag --args 4u8 7u8


//# publish
module 0xCAFE::TestLambda {
    public fun run_lambda(x: u8, y: u8): u8 {
        let lambda: |u8, u8|u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        lambda(x, y)
    }

    public fun run_no_arg_lambda(): u8 {
        let lambda: |()|u8 has copy+drop = || {
            42u8
        };
        lambda()
    }
}


//# run 0xCAFE::TestLambda::run_lambda --args 5u8 6u8


//# run 0xCAFE::TestLambda::run_no_arg_lambda


//# publish
module 0xCAFE::InlineCaller {
    use 0xCAFE::TestLambda;

    public inline fun inline_adder(a: u8, b: u8): u8 {
        a + b
    }

    public fun call_inline_and_lambda(a: u8, b: u8): u8 {
        let inline_result = inline_adder(a, b);
        let lambda_result = TestLambda::run_lambda(a, b);
        inline_result + lambda_result
    }
}


//# run 0xCAFE::InlineCaller::call_inline_and_lambda --args 10u8 20u8


//# publish
module 0xCAFE::AbortTest {
    public fun abort_if_over_100(x: u64) {
        if (x > 100) {
            abort(777u64);
        };
        // complete without abort
    }
}


//# run 0xCAFE::AbortTest::abort_if_over_100 --args 50u64


//# run 0xCAFE::AbortTest::abort_if_over_100 --args 150u64


//# publish
module 0xCAFE::ComplexTypes {
    struct Nested<T> has copy, drop {
        field1: T,
        field2: (u8, u8),
        func: |T, u8| (u8, u8) has copy+drop,
    }

    public fun create_and_use_nested(x: u8): (u8, u8) {
        let f: |u8, u8| (u8, u8) has copy+drop = |a: u8, b: u8| {
            (a + b, a * b)
        };
        let n = Nested<u8> {
            field1: x,
            field2: (x, x + 1),
            func: copy f,
        };
        let (sum, product) = (n.func)(n.field1, n.field2.1);
        (sum, product)
    }
}


//# run 0xCAFE::ComplexTypes::create_and_use_nested --args 7u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 830c876c24f59db8f7cfb196485223b4: Abort execution using the 'abort' keyword followed by an expression to specify the abort value.
// 9fd62ea3370c57398899b86c1c46384f: Create complex and nested types such as tuples, function types, and type applications with parameters.
