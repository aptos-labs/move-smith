
//# publish
module 0xCAFE::LambdaTest {
    /// Simple add function returning sum of two u8 arguments plus 5
    public fun add_and_offset(a: u8, b: u8): u8 {
        let c = a + b;
        c + 5
    }

    /// Function with lambda which adds 2 to input and then multiplies by 3 using lambda
    public fun lambda_operations(x: u8): u8 {
        let add_two: |u8| u8 has copy+drop = |v: u8| { v + 2 };
        let mult_three: |u8| u8 has copy+drop = |v: u8| { v * 3 };
        let y = add_two(x);
        mult_three(y)
    }
}


//# run 0xCAFE::LambdaTest::add_and_offset --args 10u8 20u8


//# run 0xCAFE::LambdaTest::lambda_operations --args 4u8


//# publish
module 0xCAFE::NestedCalls {
    use 0xCAFE::LambdaTest;

    /// Returns sum of adding two values then multiplied by 3,
    /// using LambdaTest::add_and_offset internally
    public fun nested_test(a: u8, b: u8): u8 {
        let sum_offset = LambdaTest::add_and_offset(a, b);
        // use lambda to double the sum_offset
        let double_lambda: |u8| u8 has copy+drop = |x: u8| { x * 2 };
        double_lambda(sum_offset)
    }
}


//# run 0xCAFE::NestedCalls::nested_test --args 5u8 7u8


//# publish
module 0xCAFE::LocalVarLoopTest {
    /// Function tests local variable retains initial parameter value after loop
    public fun local_var_after_loop(x: u8): u8 {
        let local_x = x;
        // loop changes local_x local variable?
        let temp = local_x;
        while (temp < 10) {
            temp = temp + 1;
        };
        // return local_x (must still be original x)
        local_x
    }
}


//# run 0xCAFE::LocalVarLoopTest::local_var_after_loop --args 3u8


//# run 0xCAFE::LocalVarLoopTest::local_var_after_loop --args 10u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 6f5f61aca68bb9b18e3e5b13b702392d: Test that a local variable assigned from a function parameter retains its value after a loop containing reassignments.
