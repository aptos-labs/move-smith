
//# publish
module 0xCAFE::TestAddition {
    public fun add_two_u8(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return a fixed value to confirm calculation done before return
        42u8
    }
}


//# run 0xCAFE::TestAddition::add_two_u8 --args 10u8 20u8



//# publish
module 0xCAFE::TestLambda {
    public fun apply_lambda_to_5(): u8 {
        let increment: |u8|u8 has copy+drop = |x: u8| { x + 1u8 };
        increment(5u8)
    }

    public fun double_then_add_lambda(x: u8): u8 {
        let double: |u8|u8 has copy+drop = |y: u8| { y * 2u8 };
        let add_five: |u8|u8 has copy+drop = |z: u8| { z + 5u8 };
        add_five(double(x))
    }
}


//# run 0xCAFE::TestLambda::apply_lambda_to_5


//# run 0xCAFE::TestLambda::double_then_add_lambda --args 3u8



//# publish
module 0xCAFE::InlineCallTest {
    public inline fun inc_and_double(x: u8): u8 {
        let y = x + 1u8;
        y * 2u8
    }

    public fun call_inc_and_double(x: u8): u8 {
        let y = inc_and_double(x);
        y + 3u8
    }
}


//# publish
module 0xCAFE::CrossModuleCaller {
    use 0xCAFE::InlineCallTest;

    public fun call_inline_indirectly(x: u8): u8 {
        InlineCallTest::call_inc_and_double(x)
    }
}


//# run 0xCAFE::InlineCallTest::call_inc_and_double --args 4u8


//# run 0xCAFE::CrossModuleCaller::call_inline_indirectly --args 4u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
