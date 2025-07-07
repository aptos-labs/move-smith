
//# publish
module 0xCAFE::TestAddition {
    public fun add_and_return(x: u8, y: u8): u8 {
        let sum = x + y;
        if (sum > 0) {
            42u8
        } else {
            0u8
        }
    }
}


//# run 0xCAFE::TestAddition::add_and_return --args 10u8 32u8



//# publish
module 0xCAFE::TestLambda {
    public fun lambda_example(x: u8, y: u8): u8 {
        let transform: |u8, u8|u8 has copy+drop = |a: u8, b: u8| {
            a * b + a
        };
        transform(x, y)
    }

    public fun run_lambda() {
        let res = lambda_example(3u8, 4u8);
        let f: |u8|u8 has copy+drop = |a: u8| a + 1;
        let _ = f(10u8);
    }
}


//# run 0xCAFE::TestLambda::lambda_example --args 3u8 7u8


//# run 0xCAFE::TestLambda::run_lambda



//# publish
module 0xCAFE::TestInlineCall {
    use 0xCAFE::TestAddition;

    public inline fun inline_add(a: u8, b: u8): u8 {
        TestAddition::add_and_return(a, b)
    }

    public fun caller_function(x: u8, y: u8): u8 {
        inline_add(x, y)
    }
}


//# run 0xCAFE::TestInlineCall::caller_function --args 20u8 22u8



//# publish
module 0xCAFE::TestArrayIndexing {
    public fun access_element(): u8 {
        let arr = vector[10u8, 20u8, 30u8, 40u8];
        let x = arr[2];
        x
    }
}


//# run 0xCAFE::TestArrayIndexing::access_element



//# publish
module 0xCAFE::TestForLoop {
    public fun sum_0_to_4(): u64 {
        let acc = 0u64;
        for (i in 0..5) {
            acc = acc + i;
        };
        acc
    }
}


//# run 0xCAFE::TestForLoop::sum_0_to_4



//# publish
module 0xCAFE::TestFooFunction {
    public fun foo(p: u8, _cond: bool): u8 {
        p
    }

    public fun test_foo() {
        let res_true = foo(7u8, true);
        let res_false = foo(7u8, false);

        assert!(res_true == 7u8, 1);
        assert!(res_false == 7u8, 2);
    }
}


//# run 0xCAFE::TestFooFunction::test_foo


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// d7251deb557b3a3afcdca0d1bf9f3502: Index into arrays or vectors using square brackets, such as `vec[i]`.
// 0b3ffb2ff8b093cf98acf7b73966a688: Write for-loops in Move code using the syntax: for (iter in lower_bound..upper_bound) { /* loop body */ }
// f131dd4886ed90171984346fc658f187: Test that the function `foo` correctly returns the value of `p` regardless of the boolean input by verifying assertions with true and false inputs.
