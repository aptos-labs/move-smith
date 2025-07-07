
//# publish
module 0xCAFE::LambdaTest {
    use std::signer;

    public fun add_and_return_sum(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return a fixed value after addition to check correct computation and return behavior
        42u8
    }

    public fun use_lambda(a: u8, b: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        lambda(a, b)
    }

    public fun mutate_via_reference(r: &mut u8, val: u8) {
        *r = val;
    }

    public fun run_lambda() {
        let lambda: |u8| u8 has copy+drop = |x: u8| {
            x * 2
        };
        let _result = lambda(10u8);
    }
}


//# run 0xCAFE::LambdaTest::add_and_return_sum --args 10u8 5u8


//# run 0xCAFE::LambdaTest::use_lambda --args 7u8 8u8


//# run 0xCAFE::LambdaTest::run_lambda



//# publish
module 0xCAFE::InlineCallUser {
    use 0xCAFE::LambdaTest;

    public fun call_inline_lambda_add(a: u8, b: u8): u8 {
        // Call function from LambdaTest module which uses lambda expression
        LambdaTest::use_lambda(a, b)
    }

    public fun call_add_and_return_sum(a: u8, b: u8): u8 {
        // Call the add_and_return_sum function from LambdaTest to test inline call and nested call
        LambdaTest::add_and_return_sum(a, b)
    }

    public fun mutate_example() {
        let val = 10u8;
        LambdaTest::mutate_via_reference(&mut val, 255u8);
        // val should now be 255, no return needed, test runtime mutation via reference
    }
}


//# run 0xCAFE::InlineCallUser::call_inline_lambda_add --args 20u8 22u8


//# run 0xCAFE::InlineCallUser::call_add_and_return_sum --args 100u8 23u8


//# run 0xCAFE::InlineCallUser::mutate_example


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 3c4ef6781182c514710942e890407986: Mutate values through references using dereference assignments (e.g., *x = value)
