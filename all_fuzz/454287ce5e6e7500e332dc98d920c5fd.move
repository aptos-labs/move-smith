
//# publish
module 0xCAFE::TestAddition {
    public fun add_and_return(u: u8, v: u8): u8 {
        let sum = u + v;
        let target = 42u8;
        if (sum == target) {
            100u8
        } else {
            0u8
        }
    }
}


//# run 0xCAFE::TestAddition::add_and_return --args 40u8 2u8


//# publish
module 0xCAFE::TestLambda {
    public fun use_lambda(x: u8, y: u8): u8 {
        let adder: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        adder(x, y)
    }

    public fun nested_lambda(x: u8): u8 {
        let inner_lambda: |u8| u8 has copy+drop = |a: u8| {
            let multiplier: |u8,u8| u8 has copy+drop = |b: u8, c: u8| {
                b * c
            };
            multiplier(a, 2u8)
        };
        inner_lambda(x)
    }
}


//# run 0xCAFE::TestLambda::use_lambda --args 6u8 7u8


//# run 0xCAFE::TestLambda::nested_lambda --args 5u8


//# publish
module 0xCAFE::NestedCall {
    use 0xCAFE::TestAddition;

    public fun call_add_and_return(u: u8, v: u8): u8 {
        TestAddition::add_and_return(u, v)
    }

    public fun runner(): u8 {
        let a = 20u8;
        let b = 22u8;
        call_add_and_return(a, b)
    }
}


//# run 0xCAFE::NestedCall::call_add_and_return --args 30u8 12u8


//# run 0xCAFE::NestedCall::runner


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
