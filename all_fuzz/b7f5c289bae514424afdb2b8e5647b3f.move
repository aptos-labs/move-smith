
//# publish
module 0xCAFE::TestAddition {
    public fun add_two_u8(a: u8, b: u8): u8 {
        let sum = a + b;
        if (sum > 100) {
            100u8
        } else {
            sum
        }
    }
}


//# run 0xCAFE::TestAddition::add_two_u8 --args 50u8 60u8


//# publish
module 0xCAFE::TestLambda {
    public fun call_lambda_twice(x: u8): u8 {
        let lambda: |u8| u8 has copy+drop = |a: u8| {
            a * 2
        };
        let res1 = lambda(x);
        let res2 = lambda(res1);
        res2
    }
}


//# run 0xCAFE::TestLambda::call_lambda_twice --args 4u8


//# publish
module 0xCAFE::NestedCall {
    use 0xCAFE::TestAddition;

    public inline fun inline_addition(a: u8, b: u8): u8 {
        TestAddition::add_two_u8(a, b)
    }

    public fun nested_call(a: u8, b: u8): u8 {
        let first = inline_addition(a, b);
        TestAddition::add_two_u8(first, 10u8)
    }
}


//# run 0xCAFE::NestedCall::nested_call --args 40u8 50u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
