
//# publish
module 0xCAFE::TestAddition {
    public fun add_and_check(a: u8, b: u8): u8 {
        let sum = a + b;
        if (sum == 42) {
            1
        } else {
            0
        }
    }

    public fun runner_add() {
        let _ = add_and_check(20u8, 22u8);
        let _ = add_and_check(10u8, 5u8);
    }
}


//# run 0xCAFE::TestAddition::runner_add



//# publish
module 0xCAFE::TestLambda {
    public fun apply_lambda(x: u8, y: u8): u8 {
        let add_lambda: |u8, u8| u8 has copy + drop = |a: u8, b: u8| {
            a + b
        };
        add_lambda(x, y)
    }

    public fun apply_complex_lambda(x: u8, y: u8): u8 {
        let complex_lambda: |u8, u8| u8 has copy + drop = |a: u8, b: u8| {
            let sum = a + b;
            let mul = a * b;
            if (sum > mul) {
                sum
            } else {
                mul
            }
        };
        complex_lambda(x, y)
    }

    public fun runner_lambda() {
        let _ = apply_lambda(7u8, 8u8);
        let _ = apply_complex_lambda(4u8, 3u8);
    }
}


//# run 0xCAFE::TestLambda::runner_lambda



//# publish
module 0xCAFE::TestNestedCalls {
    use 0xCAFE::TestAddition;

    public inline fun inline_double_add(x: u8): u8 {
        let (res1, _) = (x + 1, x + 2);
        res1
    }

    public fun call_nested_functions(x: u8, y: u8): u8 {
        let sum = TestAddition::add_and_check(x, y);

        let inline_res = inline_double_add(sum);

        if (inline_res > 0) {
            inline_res
        } else {
            0
        }
    }

    public fun run_test_nested() {
        let _ = call_nested_functions(20u8, 22u8);
        let _ = call_nested_functions(10u8, 5u8);
    }
}


//# run 0xCAFE::TestNestedCalls::run_test_nested


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
