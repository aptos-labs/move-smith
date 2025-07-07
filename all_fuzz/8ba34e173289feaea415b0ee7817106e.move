
//# publish
module 0xCAFE::AddAndLambdaTest {
    public fun add_two_values(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return sum plus 10 for testing
        sum + 10
    }

    public fun use_lambda_twice(a: u8, b: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x * y
        };
        let val1 = lambda(a, b);
        let val2 = lambda(b, a);
        val1 + val2
    }
}


//# run 0xCAFE::AddAndLambdaTest::add_two_values --args 3u8 4u8


//# run 0xCAFE::AddAndLambdaTest::use_lambda_twice --args 5u8 2u8


//# publish
module 0xCAFE::InlineFunctionCaller {
    use 0xCAFE::AddAndLambdaTest;

    public inline fun inline_add(a: u8, b: u8): u8 {
        // Calls add_two_values in AddAndLambdaTest and subtracts 10 to get back original sum
        let result = AddAndLambdaTest::add_two_values(a, b);
        result - 10
    }

    public fun caller_of_inline_add(a: u8, b: u8): u8 {
        inline_add(a, b)
    }
}


//# run 0xCAFE::InlineFunctionCaller::caller_of_inline_add --args 7u8 8u8


//# publish
module 0xCAFE::MutableRefTest {
    public fun test_mut_ref_after_move(x: u8): u8 {
        let local = x;
        let ref_local: &u8 = &local;
        // Mut reference to a copy, no mutation done
        let mut_ref_local: &mut u8 = &mut (copy local);
        *mut_ref_local = 42;
        *ref_local
    }
}


//# run 0xCAFE::MutableRefTest::test_mut_ref_after_move --args 9u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// a3c0483adbeb6661035239f5d328ab98: Verify that taking a mutable reference to a function parameter after moving it to a local variable does not affect the value of the local variable.
